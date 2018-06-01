
[] call compile preProcessFilelineNumbers "module_core\log\config.sqf";

pvpfw_fnc_log_show = {
	if (!hasInterface)exitWith{};

	_message = param [0,""];
	_requiredLevel = param [1,0];

	if (_requiredLevel > pvpfw_logLevel) exitWith{};

	if (typeName _message != "STRING")then{
		_message = str(_message);
	};

	_var = missionNamespace getVariable[_message,nil];
	if (!isNil "_var")then{
		_message = format["%1 is %2",_message,_var];
	};

	_message = str(_requiredLevel) + "| " + _message;

	pvpfw_log_bufferArray set[pvpfw_log_bufferArrayIndex,[_message,diag_tickTime]];
	pvpfw_log_bufferArrayIndex = pvpfw_log_bufferArrayIndex + 1;
	if (pvpfw_log_bufferArrayIndex > pvpfw_log_bufferArraySize)then{
		pvpfw_log_bufferArrayIndex = 0;
	};
};

if (!hasInterface)exitWith{};

if (["pvpfw_log", "onEachFrame"] call pvpfw_fnc_cse_inStacked)then{
	["pvpfw_log", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
};

[] spawn{
	sleep 0.1;
	["pvpfw_log", "onEachFrame", {
		disableSerialization;

		if(isNull (findDisplay 46))exitWith{["pvpfw_log", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;};

		_control = uiNameSpace getVariable ["pvpfw_log_control",(findDisplay 46) displayCtrl 7001];

		if (isNull _control)then{
			_control = findDisplay 46 ctrlCreate ["RscStructuredText", 7001];

			//_control ctrlSetPosition [safezoneX,safezoneY / 3,safezoneW,safezoneY / 2];
			_control ctrlSetPosition [safeZoneX,safeZoneY + (safeZoneH / 3),safeZoneW,safeZoneH / 2];
			_control ctrlCommit 0;
			/*
			size = "(safezoneH / 40) * 0.75";
			x = 0 * (safezoneW / 40) + (safezoneX);
			y = 6 * (safezoneH / 25) + (safezoneY);
			w = 16 * (safezoneW / 40);
			h = 12 * GUI_GRID_H;
			*/
			uiNameSpace setVariable["pvpfw_log_control",_control];
			systemChat "creating log control";
		};

		if (pvpfw_logLevel == 0) exitWith{
			_control ctrlSetStructuredText parseText "";
		};

		_allText = "";

		{
			for "_i" from (_x select 0) to (_x select 1) do{
				_newText = ((pvpfw_log_bufferArray select _i)select 0);
				_timeSinceAdd = diag_tickTime - ((pvpfw_log_bufferArray select _i)select 1);
				_colorVar = if (_timeSinceAdd < pvpfw_colorTime)then[{[(0.5 + (_timeSinceAdd / pvpfw_colorTime)) * 255] call pvpfw_fnc_core_toHexadecimal},{"ff"}];

				_alphaVar = if (_timeSinceAdd > pvpfw_timeTillFade)then{
					_overtime = (_timeSinceAdd - pvpfw_timeTillFade);
					_fade = (1 - (_overtime / pvpfw_fadeTime)) max 0;
					[_fade * 255] call pvpfw_fnc_core_toHexadecimal
				}else{
					"ff"
				};
				_newText = format["<t color='#%3%2%2ff'>%1</t>",_newText,_colorVar,_alphaVar];

				_allText = _allText + _newText + "<br/>";
			};
		}forEach [[pvpfw_log_bufferArrayIndex,pvpfw_log_bufferArraySize],[0,pvpfw_log_bufferArrayIndex - 1]];

		_control ctrlSetStructuredText parseText (format["<t align='left' shadow='2'>%1</t>",_allText]);
	}] call BIS_fnc_addStackedEventHandler;
};
/*
["pvpfw_debugOfDebug"] call pvpfw_terminate;
[[],{
	scriptName "pvpfw_debugOfDebug";
	while{true}do{
		[random 999] call pvpfw_fnc_log_show;
		sleep random 1;
	};
},"pvpfw_debugOfDebug"] call pvpfw_fnc_spawn;
*/
