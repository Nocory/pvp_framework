
disableSerialization;

_dialog = createdialog "pvpfw_constr_dialog";
((findDisplay 19201) displayCtrl 2200) ctrlSetBackgroundColor [0.0,0.0,0.0,0.8];
//((findDisplay 19201) displayCtrl 2201) ctrlSetBackgroundColor [0.0,0.0,0.0,0.0]; // obsolete
((findDisplay 19201) displayCtrl 1337) ctrlSetModelScale 0.001;
//((findDisplay 19201) displayCtrl 1000) ctrlSetFontHeight 0.08;

/////////////////////////////////////
// FUNCTIONS TO POPULATE LISTBOXES //
/////////////////////////////////////

pvpfw_wg_assets_populateCategories = {
	_ctrl = ((findDisplay 19201) displayCtrl 1500);
	lbClear _ctrl;
	{
		_ctrl lbAdd (_x select 0);
	}forEach pvpfw_wg_assets_fortifications;
};

pvpfw_wg_assets_populateObjects = {
	_index = _this select 0;

	_ctrl = ((findDisplay 19201) displayCtrl 1501);
	lbClear _ctrl;

	{
		_name = _x select 0;

		if (_name == "")then{
			_name = getText (configFile >> "CfgVehicles" >> (_x select 1) >> "displayName");
		};
		_ctrl lbAdd _name;
	}forEach ((pvpfw_wg_assets_fortifications select _index) select 1);
};

pvpfw_wg_assets_selectObject = {
	_categoryIndex = lbCurSel ((findDisplay 19201) displayCtrl 1500);
	_objectIndex = _this select 0;

	_infoArray = ((pvpfw_wg_assets_fortifications select _categoryIndex) select 1) select _objectIndex;
	missionNamespace setVariable["pvpfw_wg_assets_spawnInfoTemp",[+_infoArray]];

	((findDisplay 19201) displayCtrl 1004) ctrlSetText ("Cost: " + str(_infoArray select 2));

	_type = _infoArray select 1;
	_model = getText (configFile >> "CfgVehicles" >> _type >> "model");
	_scale = _infoArray select 6;

	if (_scale == -1)then{
		_vehicle = _type createVehicleLocal [-3333,-3333,1000+(random 1000)];
		_sizeOf = sizeOf _type;
		_bBoxReal = boundingBoxReal _vehicle;
		deleteVehicle _vehicle;
		_scale = (0.2 / _sizeOf);
	};

	((findDisplay 19201) displayCtrl 1337) ctrlSetModel _model;
	((findDisplay 19201) displayCtrl 1337) ctrlSetModelScale _scale;
	((findDisplay 19201) displayCtrl 1337) ctrlSetModelDirAndUp [[0.502498,0.825237,0.257834],[-0.0565023,-0.266237,0.96225]];
};

////////////////////
// FINITIAL SETUP //
////////////////////

[] call pvpfw_wg_assets_populateCategories;
_lastCatIndex = missionNamespace getVariable["pvpfw_wg_assets_lastCatIndex",0];
((findDisplay 19201) displayCtrl 1500) lbSetCurSel _lastCatIndex;

[_lastCatIndex] call pvpfw_wg_assets_populateObjects;
_lastObjIndex = missionNamespace getVariable["pvpfw_wg_assets_lastObjIndex",0];
((findDisplay 19201) displayCtrl 1501) lbSetCurSel _lastObjIndex;
[_lastObjIndex] call pvpfw_wg_assets_selectObject;

///////////////////////////
// LISTBOX EVENTHANDLERS //
///////////////////////////

// Add objects to second list box, whenever a category in the first listbox is clicked
((findDisplay 19201) displayCtrl 1500) ctrlAddEventHandler ["LBSelChanged",{
	[_this select 1] call pvpfw_wg_assets_populateObjects;
	missionNamespace setVariable["pvpfw_wg_assets_lastCatIndex",_this select 1];
	missionNamespace setVariable["pvpfw_wg_assets_lastObjIndex",0];
	[0] call pvpfw_wg_assets_selectObject;
}];

// Update the infoArray and GUI elements, when an object name in the second listbox is clicked
((findDisplay 19201) displayCtrl 1501) ctrlAddEventHandler ["LBSelChanged",{
	_objectIndex = _this select 1;
	missionNamespace setVariable["pvpfw_wg_assets_lastObjIndex",_objectIndex];
	[_objectIndex] call pvpfw_wg_assets_selectObject;
}];

//////////////////////////
// BUTTON EVENTHANDLERS //
//////////////////////////

// buy
((findDisplay 19201) displayCtrl 1601) ctrlAddEventHandler ["ButtonClick", {
	if (isNil "pvpfw_wg_assets_spawnInfoTemp")exitWith{};
	(findDisplay 19201) closeDisplay 1;

	[] call pvpfw_fnc_constr_stopConstruction;
	pvpfw_wg_assets_spawnInfo = + pvpfw_wg_assets_spawnInfoTemp;
	[] spawn pvpfw_fnc_constr_clickedBuild;
}];

// reclaim
((findDisplay 19201) displayCtrl 1602) ctrlAddEventHandler ["ButtonClick", {
	(findDisplay 19201) closeDisplay 1;
	[] call pvpfw_fnc_constr_stopConstruction;
	[] call pvpfw_fnc_constr_clickedReclaim;
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
