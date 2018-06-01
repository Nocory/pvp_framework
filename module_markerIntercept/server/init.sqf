pvpfw_fnc_mi_log = compile preProcessFileLineNumbers "module_markerIntercept\server\log.sqf";

pvpfw_fnc_mi_handleMarkerOnServer = {
	//systemChat str(_this);
	//_this call pvpfw_fnc_mi_log;
};

"pvpfw_pv_lacm_receiveMarkerInfoServer" addPublicVariableEventhandler{
	(_this select 1) call pvpfw_fnc_mi_handleMarkerOnServer;
};