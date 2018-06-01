/****************************************
*****************************************

Module: Dogtags
Global-var-shortcut: ii_dt

Description:

Lets a player identify dead players when being next to them

*****************************************
****************************************/

[[],{
	private["_oldTarget","_newTarget"];
	_oldTarget = objNull;
	_newTarget = objNull;

	while{true}do{
		deleteVehicle (missionNamespace getVariable["pvpfw_ii_dt_sphere",objNull]);
		removeMissionEventHandler ["Draw3D", missionNamespace getVariable["pvpfw_ii_drawAutoDogTagEH",-1]];

		waitUntil{sleep 0.15; _newTarget = cursorTarget; _newTarget isKindOf "CAManBase" && !alive _newTarget && player distance _newTarget < 2.5};

		pvpfw_ii_dt_sphere = "Sign_Sphere10cm_F" createVehicleLocal (getPosATL _newTarget);
		hideObject pvpfw_ii_dt_sphere;
		pvpfw_ii_dt_sphere attachto [_newTarget,[0.0,0,0.2], "Spine3"];
		pvpfw_ii_dt_sphere setVariable ["pvpfw_text","John Doe"];

		pvpfw_ii_drawAutoDogTagEH = addMissionEventHandler ["Draw3D",{
			drawIcon3D ["", [1.0,1.0,1.0,0.8], ASLtoATL visiblePositionASL pvpfw_ii_dt_sphere, 0, 0, 0, pvpfw_ii_dt_sphere getVariable["pvpfw_text","ERROR"], 2, 0.04,"PuristaSemiBold","center"];
		}];

		_oldTarget = _newTarget;
		waitUntil{sleep 0.15;_newTarget = cursorTarget; _newTarget != _oldTarget || player distance _oldTarget > 2.5};
	}
},"pvpfw_autoDogTag"] call pvpfw_fnc_spawnOnce;
