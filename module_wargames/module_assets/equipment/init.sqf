
// TODO need to find a way to remove player equip from arsenal

[] call compile preprocessFileLineNumbers "module_wargames\module_assets\equipment\cost.sqf";

if (isServer)then{
  [] call compile preprocessFileLineNumbers "module_wargames\module_assets\equipment\server.sqf";
};

if (hasInterface)then{
  [] spawn compile preprocessFileLineNumbers "module_wargames\module_assets\equipment\client.sqf";
};
