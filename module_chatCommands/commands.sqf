pvpfw_chatIntercept_allCommands = [
	[
		"help",
		{
			_command = _this joinString " ";
			if (_command != "")then{
				{
					if (_x select 0 == _command)then{
						systemChat format["%1: %2",toUpper _command,_x param [2,"No description available"]]
					};
				}forEach pvpfw_chatIntercept_allCommands;
			}else{
				_commands = "";
				{
					_conditionCode = _x param [3,{true}];
					if ([] call _conditionCode)then{
						_commands = _commands + (pvpfw_chatIntercept_commandMarker + (_x select 0)) + ", ";
					};
				}forEach pvpfw_chatIntercept_allCommands;
				systemChat format["Available Commands: %1",_commands];
			};
		},
		"Lists all available commands or shows additional info if a command is specified"
	],
	[
		"fps",
		{
			_terminated = ["pvpfw_fnc_perf_monitorClient"] call pvpfw_fnc_terminate;
			if (_terminated) exitWith{};
			[[],pvpfw_fnc_perf_monitorClient,"pvpfw_fnc_perf_monitorClient"] call pvpfw_fnc_spawn;
		},
		"Toggles fps and performance info"
	],
	[
		"announce",
		{
			_title = format["Announcement by %1",name player];
			_message = _this joinString " ";
			["pvpfw_notification_infoLong",[_title,_message]] remoteExec ["BIS_fnc_showNotification",0];
		},
		"Allows Operation-Command to broadcast a message to all units"
	],
	[
		"global",
		{
			_string = format["<GLOBAL> %1: %2",name player,_this joinString " "];
			_string remoteExec ["systemChat",0];
		},
		"Allows Admins and Operation-Command to send a message to the global chat"
	],
	[
		"reload",
		{
			"Re-running init.sqf";
			[] call compile preprocessFileLineNumbers "init.sqf";
		},
		"Re-initializes all scripts"
	],
	[
		"echo",
		{
			systemChat format["Echo: %1",_this joinString " "];
		},
		"echoes the following characters for testing purposes"
	],
	[
		"tp",
		{
			[] call pvpfw_fnc_core_teleport;
		},
		"Allows players to teleport when training-mode is active",
		{pvpfw_param_trainingEnabled == 1}
	],
	[
		"cam",
		{
			[] call bis_fnc_camera;
		},
		"Runs the ArmA3 camera script",
		{pvpfw_param_trainingEnabled == 1}
	],
	[
		"unflip",
		{
			[] call pvpfw_fnc_core_unflip;
		},
		"Lets the driver unflip the vehicle, in case ArmA physics did their thing again"
	],
	[
		"tfr",
		{
			pvpfw_tfr_enabled = !pvpfw_tfr_enabled;
		},
		"Toggles TFR for testing purposes",
		{pvpfw_param_trainingEnabled == 1}
	]
];