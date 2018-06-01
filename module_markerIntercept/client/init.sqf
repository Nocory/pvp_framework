
call compile preProcessFileLineNumbers "module_markerIntercept\client\showNewMarkerIn3D.sqf";
pvpfw_fnc_mi_change = compile preProcessFileLineNumbers "module_markerIntercept\client\change.sqf";
pvpfw_fnc_mi_creatingNew = compile preProcessFileLineNumbers "module_markerIntercept\client\creatingNew.sqf";
pvpfw_fnc_mi_findDPID = compile preProcessFileLineNumbers "module_markerIntercept\client\findDPID.sqf";

"pvpfw_mi_pv_receiveMarkerInfoClient" addPublicVariableEventhandler{
	[(_this select 1),false] call pvpfw_fnc_mi_change;
};

// Create Markercode-hint
pvpfw_mi_confCode = "";
for "_i" from 1 to 10 do{
	pvpfw_mi_confCode = pvpfw_mi_confCode + str(floor(random 10));
};

pvpfw_handle_mi_creatingNew = [] spawn{};

[[],{
	waitUntil{!isNull (findDisplay 12 displayCtrl 51)};
	(findDisplay 12 displayCtrl 51) ctrlAddEventHandler ["mouseButtonDblClick", {
		if (!scriptDone pvpfw_handle_mi_creatingNew)then{
			systemChat "DEBUG: chatIntercept preventing double script spawn";
			terminate pvpfw_handle_mi_creatingNew;
		};
		pvpfw_handle_mi_creatingNew = [] spawn pvpfw_fnc_mi_creatingNew;
	}];

	pvpfw_mi_ctrlEH_drawHint_12 = (findDisplay 12 displayCtrl 51) ctrlAddEventHandler ["Draw",{
		if (!isNil "pvpfw_mi_DPID") then{
			(findDisplay 12 displayCtrl 51) ctrlRemoveEventHandler ["Draw",pvpfw_mi_ctrlEH_drawHint_12];
		};

		_control = _this select 0;
		_worldPos = _control ctrlMapScreenToWorld [0.5,0.4];
		_control drawIcon ["iconobject_1x1", [1,1,1,1], _worldPos, 0, 0, 0, "Double-Click Anywhere", 2, 0.1, "PuristaMedium", "center"];
	}];

	// Functionality for persistent markers, that can only be deleted by an admin
	(findDisplay 12 displayCtrl 51) ctrlAddEventHandler ["MouseMoving",{pvpfw_mi_mouseOnMapArray = _this;}];
	(findDisplay 12 displayCtrl 51) ctrlAddEventHandler ["MouseHolding",{pvpfw_mi_mouseOnMapArray = _this;}];

	pvpfw_mi_mouseOnMapArray = [];

	(findDisplay 12) displayAddEventHandler ["KeyDown",{
		_return = false;
		if (_this select 1 == 211)then{ // 211 = delete key
			_mousePos = [pvpfw_mi_mouseOnMapArray select 1,pvpfw_mi_mouseOnMapArray select 2];
			_closestMarker = "";
			_closestDist = 99;

			_ctrl = (findDisplay 12 displayCtrl 51);
			{
				_distance = _mousePos distance (_ctrl posWorldToScreen (markerPos _x));
				if (_distance < _closestDist)then{
					_closestDist = _distance;
					_closestMarker = _x;
				};
			}forEach allMapMarkers;

			if (!isMultiplayer)then{
				_mouseX = linearConversion [safeZoneX,safeZoneW + safeZoneX,_mousePos select 0,0,1,false];
				_mouseY = linearConversion [safeZoneY,safeZoneH + safeZoneY,_mousePos select 1,0,1,false];

				_markerPosToScreen = _ctrl posWorldToScreen (markerPos _closestMarker);
				_markerX = linearConversion [safeZoneX,safeZoneW + safeZoneX,_markerPosToScreen select 0,0,1,false];
				_markerY = linearConversion [safeZoneY,safeZoneH + safeZoneY,_markerPosToScreen select 1,0,1,false];

				systemChat "=================";
				//systemChat str(_mousePos);
				//systemChat str[_mouseX,_mouseY];
				//systemChat _closestMarker;
				systemChat str(_closestDist);
				systemChat str[(_mousePos select 0) - ((_ctrl posWorldToScreen (markerPos _closestMarker)) select 0),(_mousePos select 1) - ((_ctrl posWorldToScreen (markerPos _closestMarker)) select 1)];
				systemChat "=================";
				systemChat str([_mouseX,_mouseY] distance [_markerX,_markerY]);
				systemChat str[_mouseX - _markerX,_mouseY - _markerY];
			};

			if (_closestDist < 0.021 && {serverCommandAvailable "#kick" || !isMultiplayer} && {([_closestMarker,0,12] call BIS_fnc_trimString) == "pvpfw_mi_pers"})then{
				deleteMarker _closestMarker;
				_return = true;
			};
		};
		_return
	}];
},"pvpfw_fnc_mi_1"] call pvpfw_fnc_spawnOnce;

// local server briefing screen
[[],{
	waitUntil{!isNull (findDisplay 52 displayCtrl 51) || !isNil "pvpfw_mi_DPID"};

	if (isNull (findDisplay 52 displayCtrl 51)) exitWith{};

	(findDisplay 52 displayCtrl 51) ctrlAddEventHandler ["mouseButtonDblClick", {
		[] spawn pvpfw_fnc_mi_creatingNew;
	}];

	pvpfw_mi_ctrlEH_drawHint_52 = (findDisplay 52 displayCtrl 51) ctrlAddEventHandler ["Draw",{
		if (!isNil "pvpfw_mi_DPID") then{
			(findDisplay 52 displayCtrl 51) ctrlRemoveEventHandler ["Draw",pvpfw_mi_ctrlEH_drawHint_52];
		};

		_control = _this select 0;
		_worldPos = _control ctrlMapScreenToWorld [0.5,0.4];
		_control drawIcon ["iconobject_1x1", [1,1,1,1], _worldPos, 0, 0, 0, "Double-Click Anywhere", 2, 0.1, "PuristaMedium", "center"];
	}];
},"pvpfw_fnc_mi_2"] call pvpfw_fnc_spawnOnce;

// dedi server briefing screen
[[],{
	waitUntil{!isNull (findDisplay 53 displayCtrl 51) || !isNil "pvpfw_mi_DPID"};

	if (isNull (findDisplay 53 displayCtrl 51)) exitWith{};

	(findDisplay 53 displayCtrl 51) ctrlAddEventHandler ["mouseButtonDblClick", {
		[] spawn pvpfw_fnc_mi_creatingNew;
	}];

	pvpfw_mi_ctrlEH_drawHint_53 = (findDisplay 53 displayCtrl 51) ctrlAddEventHandler ["Draw",{
		if (!isNil "pvpfw_mi_DPID") then{
			(findDisplay 53 displayCtrl 51) ctrlRemoveEventHandler ["Draw",pvpfw_mi_ctrlEH_drawHint_53];
		};

		_control = _this select 0;
		_worldPos = _control ctrlMapScreenToWorld [0.5,0.4];
		_control drawIcon ["iconobject_1x1", [1,1,1,1], _worldPos, 0, 0, 0, "Double-Click Anywhere", 2, 0.1, "PuristaMedium", "center"];
	}];
},"pvpfw_fnc_mi_3"] call pvpfw_fnc_spawnOnce;

[] call compile preProcessFileLineNumbers "module_markerIntercept\client\changeAll.sqf";

if (!isMultiplayer) then{
	//pvpfw_mi_pv_DPID = 0;
};
