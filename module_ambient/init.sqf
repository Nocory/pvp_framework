/****************************************
*****************************************

Module: Ambient
Global-var-shortcut: ambient

Description:
  Provides functionality to make the mission feel more alive by spawning in civilian vehicles, aircraft flyovers, etc.

*****************************************
****************************************/

if (!isServer) exitWith{};

[] call compile preProcessFilelineNumbers "module_ambient\config.sqf";

//pvpfw_ambient_flyby = compile preProcessFileLineNumbers "module_ambient\flyby\init.sqf";
pvpfw_fnc_ambient_ambientVehicles = compile preProcessFileLineNumbers "module_ambient\ambientVehicles\init.sqf";

[[[15000,15000],99000,33,100],pvpfw_fnc_ambient_ambientVehicles,"pvpfw_fnc_ambient_ambientVehicles"] call pvpfw_fnc_spawnOnce;

/*

[[[15000,15000],99000,33,100],"module_ambient\ambientVehicles\init.sqf","pvpfw_fnc_ambient_ambientVehicles"] call pvpfw_fnc_spawn;

[[[15000,15000],99000,1,100,0.01,0],"module_ambient\ambientVehicles\init.sqf","pvpfw_fnc_ambient_ambientVehicles"] call pvpfw_fnc_spawn;

[[[15000,15000],99000,1,100,0.01,0],"module_ambient\ambientVehicles\init.sqf","pvpfw_fnc_ambient_ambientVehicles"] call pvpfw_fnc_spawn;

*/
