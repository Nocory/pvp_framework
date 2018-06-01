if (hasInterface)then{
  [] call compile preProcessFilelineNumbers "module_wargames\module_teams\client.sqf";
};

if (isServer)then{
  [] call compile preProcessFilelineNumbers "module_wargames\module_teams\server.sqf";
};
