pvpfw_respawn_vehicles = missionNamespace getVariable["pvpfw_respawn_vehicles",[]];

//[] call compile preprocessFileLineNumbers "module_respawn\server\initialVehicleCheck.sqf";
[[],"module_respawn\server\vehicleRespawnCheckLoop.sqf","pvpfw_fnc_respawn_vehicleRespawnCheckLoop"] call pvpfw_fnc_spawnOnce;

pvpfw_fnc_respawn_addVehicle = {
  // array is:
  // 0: destrTime
  // 1: vehicleObject
  // 2: classType
  // 3: respawnPos
  // 4: respawnDir
  // 5: respawnDelay
  // 6: setVariables

  _vehicle = param [1,objNull];
  if (isNull _vehicle)exitWith{};

  _type = typeof _vehicle;
  _pos = param [3,getPos _vehicle];
  _dir = param [4,direction _vehicle];
  _delay = param [5,5];
  _allVehicleVars = _vehicle getVariable ["pvpfw_allVariables",[]];

  pvpfw_respawn_vehicles pushBack [0,_vehicle,_type,_respPos,_dir,_delay,_allVehicleVars];
	diag_log format["#PVPFW module_respawn: setting respawn for %1, delay: %2",_type,_respawnDelay];
};
