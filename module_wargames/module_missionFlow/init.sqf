systemChat "mf_init";

if (isServer)then{
  [] call compile preProcessFilelineNumbers "module_wargames\module_missionFlow\server\init.sqf";
};

if (hasInterface)then{
  [[],"module_wargames\module_missionFlow\client\init.sqf","pvpfw_wg_mf_clientInit"] call pvpfw_fnc_spawnOnce;
};
