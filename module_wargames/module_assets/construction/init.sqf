/****************************************
Description:
Allows players to construct fortified positions in the field
****************************************/

call compile preProcessFileLineNumbers "module_wargames\module_assets\construction\config.sqf";

if (!isDedicated) then{
	[] call compile preProcessFileLineNumbers "module_wargames\module_assets\construction\client\init.sqf";
};

if (isServer) then{
	[] call compile preProcessFileLineNumbers "module_wargames\module_assets\construction\server\init.sqf";
};
