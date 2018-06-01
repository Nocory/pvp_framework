pvpfw_wg_system_objectiveKill = [];

{
  _killInfo = _x getVariable["pvpfw_wg_system_kill",[]];

  if (count _killInfo != 0)then{
    _atacker = _killInfo select 0;
    pvpfw_wg_system_objectiveKill pushBack [_x,_attacker,false,[] call pvpfw_fnc_core_generateID];
  };
}forEach (allMissionObjects "");

{
  _id = _x select 3;
  _killOrders = format["Eliminate %1",getText (configFile >> "CfgVehicles" >> (typeOf (_x select 0)) >> "displayName")];
  _preventOrders = format["Defend %1",getText (configFile >> "CfgVehicles" >> (typeOf (_x select 0)) >> "displayName")];

  switch(_x select 1)do{
    case(blufor):{
      pvpfw_wg_system_objectivesBlu pushBack [_id,_killOrders];
      pvpfw_wg_system_objectivesRed pushBack [_id,_preventOrders,true];
    };
    case(opfor):{
      pvpfw_wg_system_objectivesRed pushBack [_id,_killOrders];
      pvpfw_wg_system_objectivesBlu pushBack [_id,_preventOrders,true];
    };
  };
}forEach pvpfw_wg_system_objectiveKill;

[[],{
  while{true}do{
    {
      if (!alive (_x select 0) && !(_x select 3))then{
        _x set[3,true];
        pvpfw_wg_system_achievedObjectives pushBackUnique (_x select 3);
        publicVariable["pvpfw_wg_system_achievedObjectives"];
      };
      sleep 0.2;
    }forEach pvpfw_wg_system_objectiveKill;
    sleep 0.142;
  };
},"pvpfw_wg_system_objectiveKillCheck"] call pvpfw_fnc_spawnOnce;
