/****************************************
Description:
Handles player (client) and vehicle (server) respawn.
****************************************/

call compile preprocessFileLineNumbers "module_respawn\config.sqf";

if (isServer) then{
	call compile preprocessFileLineNumbers "module_respawn\server\init.sqf";
};

if (hasInterface) then{
	call compile preprocessFileLineNumbers "module_respawn\client\init.sqf";
};