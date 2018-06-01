
pvpfw_missionFlow_secsTillStart = missionNamespace getVariable["pvpfw_missionFlow_secsTillStart",121];

pvpfw_missionFlow_bluforReady = missionNamespace getVariable["pvpfw_missionFlow_bluforReady",false];
pvpfw_missionFlow_opforReady = missionNamespace getVariable["pvpfw_missionFlow_opforReady",false];
pvpfw_missionFlow_adminsReady = missionNamespace getVariable["pvpfw_missionFlow_adminsReady",false];

if (hasInterface) then{
	[[],"module_missionFlow\client\start.sqf","pvpfw_missionFlow_client_start"] call pvpfw_fnc_spawn;
	call compile preprocessFileLineNumbers "module_missionFlow\client\end.sqf";
};

if (isServer) then{
	[] call compile preprocessFileLineNumbers "module_missionFlow\server\init.sqf";
};