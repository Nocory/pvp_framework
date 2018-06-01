if (!hasInterface) exitWith{};

pvpfw_EH_allkeyDownEH = [];
pvpfw_EH_allkeyUpEH = [];
pvpfw_EH_allMouseDownEH = [];
pvpfw_EH_allMouseUpEH = [];

pvpfw_fnc_EH_addKeyEH = {
	private["_downOrUp","_identifier","_keysCode","_modifiers","_condition","_code","_scaMod","_EHArray","_addAtIndex"];
	_downOrUp = param [0,""];

	if !(_downOrUp in ["keyDown","keyUp","mouseDown","mouseUp"])exitWith{};

	_identifier = param [1,(str(diag_tickTime) + "." + str(random 1000))];
	_keysCode 	= param [2,{-1}];
	_code 		= param [3,{}];
	_condition 	= param [4,{true}];
	_modifiers 	= param [5,[]];

	_scaMod = 0; //pressed shift,control,alt
	if ("shift" in _modifiers) then{_scaMod = _scaMod + 1;};
	if ("ctrl" in _modifiers) then{_scaMod = _scaMod + 2;};
	if ("alt" in _modifiers) then{_scaMod = _scaMod + 4;};

	_EHArray = missionNamespace getVariable [format["pvpfw_EH_all%1EH",_downOrUp],[]];

	_addAtIndex = count _EHArray;
	{
		if ((_x select 0) == _identifier)exitWith{_addAtIndex = _forEachIndex};
	}forEach _EHArray;

	if (_code isEqualTo {})then{
		_EHArray set[_addAtIndex,objNull];
		_EHArray = _EHArray - [objNull];
	}else{
		_EHArray set[_addAtIndex,[_identifier,_keysCode,_scaMod,_condition,_code]];
	};

	//return the identifier
	_identifier
};

pvpfw_fnc_EH_removeKeyEH = {
	_downOrUp 	= param [0,""];
	_identifier = param [1,""];

	if !(_downOrUp in ["keyDown","keyUp","mouseDown","mouseUp"])exitWith{};

	_EHArray = missionNamespace getVariable [format["pvpfw_EH_all%1EH",_downOrUp],[]];
	{
		if ((_x select 0) == _identifier)exitWith{
			_EHArray set[_forEachIndex,objNull]
		};
	}forEach _EHArray;
	_EHArray = _EHArray - [objNull];
	missionNamespace setVariable [format["pvpfw_EH_all%1EH",_downOrUp],_EHArray];
};

[[],{
	scriptName "pvpfw_addKeyEH_monitor";

	waitUntil{sleep 0.1;!isNull (findDisplay 46)};

	_initTime = diag_tickTime;

	(findDisplay 46) displayRemoveAllEventHandlers "MouseButtonDown";
	(findDisplay 46) displayRemoveAllEventHandlers "MouseButtonUp";

	while{diag_tickTime < (_initTime + 60)}do{
		{
			_EHVar = _x select 0;
			_eventType = _x select 1;
			_array = _x select 2;

			if ((missionNamespace getVariable[_EHVar,-1]) == -1)then{
				_newID = call compile format[
					'(findDisplay 46) displayAddEventHandler ["%1",{
						_keyPressed = _this select 1;

						["Key: " + str(_keyPressed),4] call pvpfw_fnc_log_show;

						_disableDefaultAction = false;

						{
							if (_keyPressed == (_x select 1))then{
								// get required and pressed (shift,ctrl,alt) modifer keys
								_scaModRequired = _x select 2;
								_scaModPressed = 0;
								// if a modifier key is required we will check if it's pressed
								if (_scaModRequired != 0) then{
									if (_this select 2) then{_scaModPressed = _scaModPressed + 1;}; // shift
									if (_this select 3) then{_scaModPressed = _scaModPressed + 2;}; // ctrl
									if (_this select 4) then{_scaModPressed = _scaModPressed + 4;}; // alt
								};
								// check if the modifier key fits and if the condition for the action is true as well
								if (_scaModRequired == _scaModPressed && {[] call (_x select 3)})then{
									[] call (_x select 4);
									_disableDefaultAction = true;
								};
							};
						}forEach %2;

						_disableDefaultAction
					}];
				',_eventType,_array];
				missionNamespace setVariable[_EHVar,_newID];
			};
			sleep 0.1;
		}forEach [
			["pvpfw_EH_mainKeyDownEH","KeyDown","pvpfw_EH_allkeyDownEH"],
			["pvpfw_EH_mainKeyUpEH","KeyUp","pvpfw_EH_allkeyUpEH"],
			["pvpfw_EH_mainMouseDownEH","MouseButtonDown","pvpfw_EH_allMouseDownEH"],
			["pvpfw_EH_mainMouseUpEH","MouseButtonUp","pvpfw_EH_allMouseUpEH"]
		];
		sleep 0.1
	};

	["Removing pvpfw_addKeyEH_monitor",2] call pvpfw_fnc_log_show;
},"pvpfw_addKeyEH_monitor"] call pvpfw_fnc_spawn;
