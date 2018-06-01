pvpfw_wg_system_objectiveCapture = [];

for "_i" from 0 to 50 do{
  _marker = format["pvpfw_wg_system_capture_%1",_i];
  if (markerColor _x != "")then{
    _attacker = switch(markerColor _x)do{
      case("ColorBlue"):{opfor};
      case("ColorBlufor"):{opfor};
      case("ColorRed"):{blufor};
      case("ColorOpfor"):{blufor};
      default{civilian};
    };
    if (_attacker in [blufor,opfor])then{
      pvpfw_wg_system_objectiveCapture pushBack[_x,_attacker,false,[] call pvpfw_fnc_core_generateID];
    }
  };
};

[[],{
  while{true}do{
    // TODO check objectives here
    sleep 1;
  };
},"pvpfw_wg_system_objectiveCaptureCheck"] call pvpfw_fnc_spawnOnce;
