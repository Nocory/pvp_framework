pvpfw_fnc_chatIntercept_executeCommand = {
	private ["_chatString","_splitString","_commandDone","_command","_argument"];

	if (isServer && count allPlayers == 1)then{
		[] call compile preprocessFileLineNumbers "module_chatCommands\init.sqf";
	};

	_chatString = _this select [1];
	_splitString = _chatString splitString " ";

	if (count _splitString == 0) exitWith{};

	_command = _splitString deleteAt 0;

	{
		if (_command == (_x select 0))exitWith{
			_conditionCode = _x param [3,{true}];
			if ([] call _conditionCode)then{
				_splitString call (_x select 1);
			};
		};
	}forEach pvpfw_chatIntercept_allCommands;
};

pvpfw_fnc_chatIntercept_addCommand = {
	_command 	= param [0,"NOT_SET"];
	_code 		= param [1,{false}];
	_condition 	= param [2,{true}];

	{
		if ((_x select 0) == _command) exitWith{
			[format["Updating chat command: %1",_command],2] call pvpfw_fnc_debug_show;
			pvpfw_chatIntercept_allCommands set[_forEachIndex,[_command,_code,_condition]];
		};
	}forEach pvpfw_chatIntercept_allCommands;

	[format["Adding chat command: %1",_command],2] call pvpfw_fnc_debug_show;
	pvpfw_chatIntercept_allCommands pushBack [_command,_code,_condition];
};
