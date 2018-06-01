pvpfw_wg_system_objectiveEscort = [];

{
  _escortInfo = _x getVariable["pvpfw_wg_system_escort",[]];

  if (count _escortInfo != 0)then{
    _escortSide = _escortInfo param[0,civilian];
    _targetPos = markerPos (_escortInfo param[1,""]);

    _id = [] call pvpfw_fnc_core_generateID;

    pvpfw_wg_system_allObjectives pushBack []

    pvpfw_wg_system_objectiveEscort pushBack [_x,_escortSide,_targetPos,false,[] call pvpfw_fnc_core_generateID];
  };
}forEach (allMissionObjects "");

{
  _id = _x select 4;
  _escortOrders = format["Escort %1 to its destination",getText (configFile >> "CfgVehicles" >> (typeOf (_x select 0)) >> "displayName")];
  _preventOrders = format["Prevent %1 from reaching its destination",getText (configFile >> "CfgVehicles" >> (typeOf (_x select 0)) >> "displayName")];

  switch(_x select 1)do{
    case(blufor):{
      pvpfw_wg_system_objectivesBlu pushBack [_id,_escortOrders];
      pvpfw_wg_system_objectivesRed pushBack [_id,_preventOrders,true];
    };
    case(opfor):{
      pvpfw_wg_system_objectivesRed pushBack [_id,_escortOrders];
      pvpfw_wg_system_objectivesBlu pushBack [_id,_preventOrders,true];
    };
  };
}forEach pvpfw_wg_system_objectiveEscort;

[[],{
  while{true}do{
    {
      _object = _x select 0;
      _targetPos = _x select 2;
      if (!(_x select 3) && _object distance2D _targetPos < 15)then{
        _x set[3,true];
        pvpfw_wg_system_achievedObjectives pushBackUnique (_x select 4);
        publicVariable["pvpfw_wg_system_achievedObjectives"];
      };
      sleep 0.2;
    }forEach pvpfw_wg_system_objectiveEscort;
    sleep 0.142;
  };
},"pvpfw_wg_system_objectiveEscortCheck"] call pvpfw_fnc_spawnOnce;
