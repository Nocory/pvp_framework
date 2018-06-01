
pvpfw_wg_assets_funds_blu = missionNamespace getVariable["pvpfw_wg_assets_funds_blu",5000];
pvpfw_wg_assets_funds_red = missionNamespace getVariable["pvpfw_wg_assets_funds_red",5000];

[] call compile preprocessFileLineNumbers "module_wargames\module_assets\funds\functions.sqf";

if (isServer)then{
  [[],"module_wargames\module_assets\funds\server.sqf","pvpfw_wg_assets_funds"] call pvpfw_fnc_spawnOnce;
};

if (!isDedicated)then{
  [] call compile preprocessFileLineNumbers "module_wargames\module_assets\funds\client.sqf";
};
