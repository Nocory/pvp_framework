if (!hasInterface) exitWith{};

call compile preProcessFileLineNumbers "module_vehicleService\config.sqf";
pvpfw_fnc_vehService_startService = compile preprocessFileLineNumbers "module_vehicleService\startService.sqf";