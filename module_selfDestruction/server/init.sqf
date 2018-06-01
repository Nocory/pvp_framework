pvpfw_fnc_selfdestruct_initDestr = compile preprocessFileLineNumbers "module_selfDestruction\server\selfDestructVehicle.sqf";

"pvpfw_pv_selfDestruct_vehicle" addPublicVariableEventhandler {
	_varName = _this select 0;
	_varValue = _this select 1;
	
	[_varValue,pvpfw_fnc_selfdestruct_initDestr,"pvpfw_fnc_selfdestruct_initDestr"] call pvpfw_fnc_spawn;
};