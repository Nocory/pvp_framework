if (!isServer) exitWith{};

pvpfw_stats_casVeh_BLU = [];
pvpfw_stats_casVeh_RED = [];
pvpfw_stats_casVeh_IND = [];
pvpfw_stats_casVeh_CIV = [];

pvpfw_fnc_stats_addVehCas = {
	_unit = param [0,objNull];
	// TODO use setvard faction on  the vehicle instead of its actual faction
	_varString = format ["pvpfw_stats_casVeh_%1",_unit getVariable["pvpfw_customSideString","CIV"]];
	_casVehFactionArr = missionNamespace getVariable [_varString,[]];
	_casVehFactionArr pushBack (typeOf _unit);
	missionNamespace setVariable [_varString,_casVehFactionArr];
};
