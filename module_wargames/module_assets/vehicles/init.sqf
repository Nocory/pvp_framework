/****************************************
Description:
Allows officers to purchase vehicles in the base
****************************************/

call compile preProcessFileLineNumbers "module_wargames\module_assets\vehicles\config.sqf";

if (!isDedicated) then{
	[] call compile preProcessFileLineNumbers "module_wargames\module_assets\vehicles\client\init.sqf";
};

if (isServer) then{
	[] call compile preProcessFileLineNumbers "module_wargames\module_assets\vehicles\server\init.sqf";
};
