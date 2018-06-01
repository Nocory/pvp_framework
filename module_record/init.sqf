[[],"module_record\whoPlayed.sqf","whoPlayed"] call pvpfw_fnc_spawn;

if (!isServer || isNil "pvpfw_pers_running") exitWith{};
if !(profileName in ["AW_Battle","[AW]Conroy"]) exitWith{};

[] call compile preProcessFileLineNumbers "module_record\config.sqf";

[[],"module_record\record.sqf","record"] call pvpfw_fnc_spawn;