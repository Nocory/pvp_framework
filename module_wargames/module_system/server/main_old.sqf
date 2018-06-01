
_colorizeObjective = {
  _objectiveMarker = param[0,""];
  _color = param[1,"ColorWhite"];
  _alpha = param[2,0];

  for "_i" from 1 to 5 do{
    _marker = format["%1_influence_%2",_objMarker,_i];
    _marker setMarkerAlphaLocal _alpha;
    _marker setMarkerColor _color;
  };

  _marker = format["%1_white",_objMarker];
  _marker setMarkerColor _color;
};

pvpfw_wg_system_objScore = missionNamespace getVariable["pvpfw_wg_system_objScore",[]];
pvpfw_wg_system_objInfluence = missionNamespace getVariable["pvpfw_wg_system_objInfluence",[]];

_maxRange = 200;
_minRange = 100;

_maxInfluence = 5;

_passedParam = param[0,""];

switch(_passedParam)do{
  case("reset"):{
    pvpfw_wg_system_objScore resize 0;
    pvpfw_wg_system_objInfluence resize 0;
  };
};

if (count pvpfw_wg_system_objScore == 0)then{
  pvpfw_wg_system_objScore resize (count pvpfw_wg_system_allObjectives);
  pvpfw_wg_system_objScore apply {0};
  pvpfw_wg_system_objInfluence resize (count pvpfw_wg_system_allObjectives);
  pvpfw_wg_system_objInfluence apply {0};
};

while{pvpfw_wg_mf_status == 5}do{
  {
    _bluInfluence = 0;
    _redInfluence = 0;

    _objMarker = _x;
    _objPos = markerPos _objMarker;

    _nearEntities = _objPos nearEntities ["CAManBase",_maxRange];

    {
      _unitDist = (getPosATL _x) distance _objPos;
      _influence = ((_maxRange - _unitDist) / (_maxRange - _minRange)) min 1;

      switch(_x getVariable["pvpfw_customSide",civilian])do{
        case(blufor):{_bluInfluence = _bluInfluence + _influence};
        case(opfor):{_redInfluence = _redInfluence + _influence};
      };
    }forEach _nearEntities;

    _bluInfluence = _bluInfluence min _maxInfluence;
    _redInfluence = _redInfluence min _maxInfluence;
    _finalInfluence = _bluInfluence - _redInfluence;

    if (abs _finalInfluence <= 2)then{
      [_objMarker,"ColorUnknown",0] call _colorizeObjective;
    }else{
      if(_finalInfluence > 2)then{
        [_objMarker,"ColorBlufor",(0.2 / _maxInfluence) * _finalInfluence] call _colorizeObjective;
      };
      if(_finalInfluence < -2)then{
        [_objMarker,"ColorOpfor",(0.2 / _maxInfluence) * abs(_finalInfluence)] call _colorizeObjective;
      };
      pvpfw_wg_system_objScore set[_forEachIndex,(pvpfw_wg_system_objScore select _forEachIndex) + _finalInfluence];
    };

    /*
    if (_forEachIndex == 1)then{
      systemChat str(_nearEntities);
      systemChat str(player distance _objPos);
      systemChat str([_bluInfluence,_redInfluence]);
    };
    */
  }forEach pvpfw_wg_system_allObjectives;

  sleep 1;
};
