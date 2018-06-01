
disableSerialization;

// REVIEW re-using the construction dialog here instead of a separate one just for vehicles
_dialog = createdialog "pvpfw_constr_dialog";
((findDisplay 19201) displayCtrl 2200) ctrlSetBackgroundColor [0.0,0.0,0.0,0.8];
((findDisplay 19201) displayCtrl 1337) ctrlSetModelScale 0.001;
((findDisplay 19201) displayCtrl 1000) ctrlSetText "Vehicles";

((findDisplay 19201) displayCtrl 1602) ctrlSetScale 0;
((findDisplay 19201) displayCtrl 1602) ctrlCommit 0;
((findDisplay 19201) displayCtrl 1005) ctrlSetScale 0;
((findDisplay 19201) displayCtrl 1005) ctrlCommit 0;

((findDisplay 19201) displayCtrl 1501) ctrlSetBackgroundColor [1,1,1,1];
((findDisplay 19201) displayCtrl 1501) ctrlSetForegroundColor [1,1,1,1];
((findDisplay 19201) displayCtrl 1501) ctrlCommit 0;

[] spawn{
	sleep 0.05;
	ctrlDelete ((findDisplay 19201) displayCtrl 1602);
	ctrlDelete ((findDisplay 19201) displayCtrl 1005);
};

/////////////////////////////////////
// FUNCTIONS TO POPULATE LISTBOXES //
/////////////////////////////////////

pvpfw_fnc_wg_assets_vehicles_populateCategories = {
	_ctrl = ((findDisplay 19201) displayCtrl 1500);
	lbClear _ctrl;
	{
		_ctrl lbAdd (_x select 0);
	}forEach (missionNamespace getVariable ["pvpfw_wg_assets_vehicles_" + (player getVariable["pvpfw_customSideString","civ"]),[]]);
};

pvpfw_fnc_wg_assets_vehicles_populateObjects = {
	_index = _this select 0;

	_ctrl = ((findDisplay 19201) displayCtrl 1501);
	lbClear _ctrl;

	{
		_name = _x select 0;
		_pic = "";

		if (_name == "")then{
			_name = getText (configFile >> "CfgVehicles" >> (_x select 1) >> "displayName");
			_pic = getText (configFile >> "CfgVehicles" >> (_x select 1) >> "picture");
		};
		_ctrl lbAdd _name;
		_ctrl lbSetPicture [_forEachIndex, _pic];
		_ctrl lbSetPictureColor [_forEachIndex, [1,1,1,1]];
	}forEach (((missionNamespace getVariable ["pvpfw_wg_assets_vehicles_" + (player getVariable["pvpfw_customSideString","civ"]),[]]) select _index) select 1);
};

pvpfw_fnc_wg_assets_vehicles_selectObject = {
	_categoryIndex = lbCurSel ((findDisplay 19201) displayCtrl 1500);
	_objectIndex = _this select 0;

	_infoArray = (((missionNamespace getVariable ["pvpfw_wg_assets_vehicles_" + (player getVariable["pvpfw_customSideString","civ"]),[]]) select _categoryIndex) select 1) select _objectIndex;
	missionNamespace setVariable["pvpfw_wg_assets_vehicles_purchaseInfo",[_infoArray select 1, _infoArray select 2, player]];

	((findDisplay 19201) displayCtrl 1004) ctrlSetText ("Cost: " + str(_infoArray select 2));

	_type = _infoArray select 1;
	_model = getText (configFile >> "CfgVehicles" >> _type >> "model");
	_scale = -1;

	if (_scale == -1)then{
		_vehicle = _type createVehicleLocal [-3333,-3333,1000+(random 1000)];
		_sizeOf = sizeOf _type;
		_bBoxReal = boundingBoxReal _vehicle;
		deleteVehicle _vehicle;
		_scale = (0.5 / _sizeOf);
	};

	((findDisplay 19201) displayCtrl 1337) ctrlSetModel _model;
	((findDisplay 19201) displayCtrl 1337) ctrlSetModelScale _scale;
	((findDisplay 19201) displayCtrl 1337) ctrlSetModelDirAndUp [[0.502498,0.825237,0.257834],[-0.0565023,-0.266237,0.96225]];
};

////////////////////
// INITIAL SETUP //
////////////////////

[] call pvpfw_fnc_wg_assets_vehicles_populateCategories;
_lastCatIndex = missionNamespace getVariable["pvpfw_wg_assets_vehicles_lastCatIndex",0];
((findDisplay 19201) displayCtrl 1500) lbSetCurSel _lastCatIndex;

[_lastCatIndex] call pvpfw_fnc_wg_assets_vehicles_populateObjects;
_lastObjIndex = missionNamespace getVariable["pvpfw_wg_assets_vehicles_lastObjIndex",0];
((findDisplay 19201) displayCtrl 1501) lbSetCurSel _lastObjIndex;
[_lastObjIndex] call pvpfw_fnc_wg_assets_vehicles_selectObject;

///////////////////////////
// LISTBOX EVENTHANDLERS //
///////////////////////////

// Add objects to second list box, whenever a category in the first listbox is clicked
((findDisplay 19201) displayCtrl 1500) ctrlAddEventHandler ["LBSelChanged",{
	[_this select 1] call pvpfw_fnc_wg_assets_vehicles_populateObjects;
	missionNamespace setVariable["pvpfw_wg_assets_vehicles_lastCatIndex",_this select 1];
	missionNamespace setVariable["pvpfw_wg_assets_vehicles_lastObjIndex",0];
	[0] call pvpfw_fnc_wg_assets_vehicles_selectObject;
}];

// Update the infoArray and GUI elements, when an object name in the second listbox is clicked
((findDisplay 19201) displayCtrl 1501) ctrlAddEventHandler ["LBSelChanged",{
	_objectIndex = _this select 1;
	missionNamespace setVariable["pvpfw_wg_assets_vehicles_lastObjIndex",_objectIndex];
	[_objectIndex] call pvpfw_fnc_wg_assets_vehicles_selectObject;
}];

//////////////////////////
// BUTTON EVENTHANDLERS //
//////////////////////////

// buy
((findDisplay 19201) displayCtrl 1601) ctrlAddEventHandler ["ButtonClick", {
	if (isNil "pvpfw_wg_assets_vehicles_purchaseInfo")exitWith{};
	(findDisplay 19201) closeDisplay 1;

	pvpfw_pv_wg_assets_vehicles_purchaseInfo = +pvpfw_wg_assets_vehicles_purchaseInfo;

	if (isServer) then{
		pvpfw_pv_wg_assets_vehicles_purchaseInfo call pvpfw_wg_assets_vehicles_handlePurchase;
	}else{
		publicVariableServer "pvpfw_pv_wg_assets_vehicles_purchaseInfo";
	};
}];

// exit
((findDisplay 19201) displayCtrl 1600) ctrlAddEventHandler ["ButtonClick", {
	(findDisplay 19201) closeDisplay 1;
}];

/////////////////////
// GUI UPDATE LOOP //
/////////////////////

while{!isNull (findDisplay 19201)}do{
	_fundString = format["Funds: %1",[] call pvpfw_fnc_wg_assets_getFunds];
	((findDisplay 19201) displayCtrl 1003) ctrlSetText _fundString;
	sleep 0.1;
};
