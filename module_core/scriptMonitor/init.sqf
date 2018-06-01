pvpfw_scriptMonitor_activeScripts = [];

pvpfw_nullHandle = [] spawn{true};

pvpfw_fnc_spawn = {
	private ["_scriptHandle","_params","_code","_identifier"];
	// This function will (*should*) always get at least 2 arguments with the third one always being a string-description
	// Not having to check param type speeds it up quite a bit

	_scriptHandle = scriptNull;

	_params = _this select 0;
	_code = _this select 1;
	_identifier = param [2,""];

	if (_identifier == "")exitWith{
		systemchat "ERROR";
		systemchat "Trying to spawn a script without identifier";
		["ERROR: trying to spawn without identifier",1] call pvpfw_fnc_log_show;
	};

	switch(typename _code)do{
		case ("CODE"):{_scriptHandle = _params spawn _code;};
		case ("STRING"):{_scriptHandle = _params spawn compile preprocessFileLineNumbers _code;};
	};

	[format["Spawning %1",_identifier],2] call pvpfw_fnc_log_show;

	pvpfw_scriptMonitor_activeScripts pushBack [_scriptHandle,_identifier];

	_scriptHandle
};

pvpfw_fnc_terminate = {
	private["_scriptToTerminate","_terminated"];

	_scriptToTerminate = param [0,"ERROR_NO_SCRIPT"];
	
	_terminated = false;
	{
		if ((_x select 1) == _scriptToTerminate) then{
			terminate (_x select 0);
			[format["Terminating %1",_scriptToTerminate],2] call pvpfw_fnc_log_show;
			_terminated = true;
		};
	}forEach pvpfw_scriptMonitor_activeScripts;
	_terminated
};

pvpfw_fnc_spawnOnce = {
	private ["_identifier"];
	_identifier = param [2,""];
	[_identifier] call pvpfw_fnc_terminate;
	_this call pvpfw_fnc_spawn;
};

[[],{
	scriptName "pvpfw_scriptMonitor";
	while{true}do{
		{
			if (scriptDone (_x select 0)) then{
				pvpfw_scriptMonitor_activeScripts deleteAt _forEachIndex;
			};
			sleep 0.1;
		}forEach pvpfw_scriptMonitor_activeScripts;
		sleep 0.218;
	};
},"pvpfw_scriptMonitor"] call pvpfw_fnc_spawn;
