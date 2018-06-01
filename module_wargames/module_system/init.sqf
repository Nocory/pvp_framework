
if (hasInterface)then{
  [] call compile preProcessFilelineNumbers "module_wargames\module_system\client\init.sqf";
};

if (isServer)then{
  [] call compile preProcessFilelineNumbers "module_wargames\module_system\server\init.sqf";
};
