
call compile preProcessFileLineNumbers "module_repairs\config.sqf";
call compile preProcessFileLineNumbers "module_repairs\functions.sqf";
call compile preProcessFileLineNumbers "module_repairs\open.sqf";

disableSerialization;

pvpfw_repairs_vehicle = cursorTarget;

pvpfw_repairs_checkConditions = {
	(alive player && cursorTarget == pvpfw_repairs_vehicle && alive pvpfw_repairs_vehicle && (player distance pvpfw_repairs_vehicle) < 5 && !isEngineOn pvpfw_repairs_vehicle)
};

if (isNull pvpfw_repairs_vehicle) exitWith{};
if !(pvpfw_repairs_vehicle isKindof "Car" || pvpfw_repairs_vehicle isKindOf "Air") exitWith{};
if ((player distance pvpfw_repairs_vehicle) > 5)exitWith{};

// Add vehicle EH if none is set yet
if !(pvpfw_repairs_vehicle getVariable ["pvpfw_repairs_EHSet",false])then{
	pvpfw_repairs_vehicle addEventhandler["Fired",{
		if(!isNil "pvpfw_repairs_handle")then{
			terminate pvpfw_repairs_handle;
		};
	}];
	
	pvpfw_repairs_vehicle setVariable["pvpfw_repairs_EHSet",true,false];
};

_dialog = createdialog "pvpfw_core_dialog";

_w = (safezoneW / 40);
_h = (safezoneH / 25);

_display = uiNamespace getVariable["pvpfw_core_dialog",displayNull];

/*
_backControl = _display ctrlCreate ["IGUIBack", -1];
_borderControl = _display ctrlCreate ["RscFrame", -1];

_w = (safezoneW / 40);
_h = (safezoneH / 25);
_x = 0.5 - ((_w * 10) * 1.1);
_y = 0.5 - ((_h * 6) * 1.1);

_backControl ctrlSetPosition [_x,_y,_w * 20,_h * 20];
_borderControl ctrlSetPosition [_x,_y,_w * 20,_h * 20];
_backControl ctrlCommit 0;
_borderControl ctrlCommit 0;
*/

KK_fnc_inString = {
	private ["_needle","_haystack","_needleLen","_hay","_found"];
	_needle = [_this, 0, "", [""]] call BIS_fnc_param;
	_haystack = toArray ([_this, 1, "", [""]] call BIS_fnc_param);
	
	_needleLen = count toArray _needle;
	_hay = +_haystack;
	
	_hay resize _needleLen;
	
	_found = false;
	
	for "_i" from _needleLen to (count _haystack) do {
		if (toString _hay == _needle) exitWith {_found = true};
		_hay set [_needleLen, _haystack select _i];
		_hay set [0, "x"];
		_hay = _hay - ["x"];
	};
	
	_found
};



pvpfw_repairs_startRepairs = {
	if(!isNil "pvpfw_repairs_handle")then{
		terminate pvpfw_repairs_handle;
	};
	
	pvpfw_repairs_handle = _this spawn{
		disableSerialization;
		
		_configName = _this select 0;
		_display = uiNamespace getVariable["pvpfw_core_dialog",displayNull];
		
		systemChat format["Preparing repairs (%1)",_this select 1];
		sleep 1;
		if (isNull _display) exitWith{};
		systemChat format["Now repairing (%1)",_configName];
		
		while{!isNull _display && ([] call pvpfw_repairs_checkConditions)}do{
			_damage = pvpfw_repairs_vehicle getHitPointDamage _configName;
			
			if (isNil "_damage")exitWith{};
			
			pvpfw_repairs_vehicle setHitPointDamage [_configName, (_damage - 0.1) max 0];
			sleep 2;
		};
	};
};

_integControl = _display ctrlCreate ["RscText", -1];
_integControl ctrlSetPosition [0.5 - (_w * 12),0.5 - (_h * 4) + (_h * -1 * 1.25),_w * 10,_h];
_integControl ctrlSetText "";
_integControl ctrlCommit 0;
	
_createRepairButton = {
	_w = (safezoneW / 40);
	_h = (safezoneH / 25);
	
	_feIndex = _this select 0;
	_configName = _this select 1;
	
	_actualName = [_configName] call pvpfw_repairs_getRepairName;
	
	if (["Glass",_actualName] call KK_fnc_inString)exitWith{controlNull};
	
	_control1 = _display ctrlCreate ["RscText", _feIndex + 1];
	_control1 ctrlSetPosition [0.5 - (_w * 12),0.5 - (_h * 4) + (_h * _feIndex * 1.25),_w * 1,_h];
	_control1 ctrlSetText "";
	_control1 ctrlCommit 0;
	
	_control2 = _display ctrlCreate ["RscButton", _feIndex + 99];
	_control2 ctrlSetPosition [0.5 - (_w * 10),0.5 - (_h * 4) + (_h * _feIndex * 1.25),_w * 5,_h];
	_control2 ctrlSetText _actualName;
	_control2 ctrlCommit 0;
	
	_control2 buttonSetAction format["['%1','%2'] call pvpfw_repairs_startRepairs",_configName,_actualName];
	
	_control1
};

_allCtrls = [];

{
	//_name = getText (_x >> "name");
	_configName = configName _x;
	
	_control = [_forEachIndex,_configName] call _createRepairButton;
	if (!isNull _control)then{
		_allCtrls pushback [_control,_configName];
	};
}forEach ("true" configClasses (configFile >> "CfgVehicles" >> (typeOf pvpfw_repairs_vehicle) >> "HitPoints"));

[_display,_allCtrls,_integControl] spawn{
	disableSerialization;
	
	_display = _this select 0;
	_allCtrls = _this select 1;
	_integControl = _this select 2;
	
	_damage = round ((1 - (damage pvpfw_repairs_vehicle)) * 100);
	
	_integControl ctrlSetText format["%1%2  -  Vehicle Integrity",_damage,"%"];
	
	while{!isNull _display && ([] call pvpfw_repairs_checkConditions)}do{
		{
			_textCtrl = _x select 0;
			_configName = _x select 1;
			
			_damage = pvpfw_repairs_vehicle getHitPointDamage _configName;
			
			_textCtrl ctrlSetText (str(round((1 - _damage) * 100))) + "%";
		}forEach _allCtrls;
		sleep 0.02;
	};
	
	(uiNamespace getVariable["pvpfw_core_dialog",displayNull]) closeDisplay 0;
	
	if(!isNil "pvpfw_repairs_handle")then{
		terminate pvpfw_repairs_handle;
	};
};