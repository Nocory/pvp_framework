[] call compile preProcessFilelineNumbers "module_chatCommands\config.sqf";
[] call compile preProcessFilelineNumbers "module_chatCommands\commands.sqf";
[] call compile preProcessFilelineNumbers "module_chatCommands\functions.sqf";

// *** HOT-RELOAD CLEANUP BEGIN
["pvpfw_handle_chatIntercept"] call pvpfw_fnc_terminate;
if (!isNil "pvpfw_chatIntercept_EHID")then{
	(findDisplay 24) displayRemoveEventHandler ["KeyDown",pvpfw_chatIntercept_EHID];
	pvpfw_chatIntercept_EHID = nil;
};
// *** HOT-RELOAD CLEANUP END

[[],{
	private["_equal"];

	while{true}do{
		pvpfw_chatString = "";

		waitUntil{sleep 0.22;!isNull (finddisplay 24 displayctrl 101)};

		pvpfw_chatIntercept_EHID = (findDisplay 24) displayAddEventHandler["KeyDown",{
			if ((_this select 1) != 28) exitWith{false};

			_equal = false;

			if (pvpfw_chatString select [0,1] == pvpfw_chatIntercept_commandMarker)then{
				if (pvpfw_chatIntercept_debug)then{
					systemChat format["Intercepted: %1",pvpfw_chatString];
				};
				_equal = true;
				closeDialog 0;
				(findDisplay 24) closeDisplay 1;

				pvpfw_chatString call pvpfw_fnc_chatIntercept_executeCommand;
			};

			if (!isNil "pvpfw_chatIntercept_EHID")then{
				(findDisplay 24) displayRemoveEventHandler ["KeyDown",pvpfw_chatIntercept_EHID];
			};
			pvpfw_chatIntercept_EHID = nil;

			_equal
		}];

		waitUntil{
			if (isNull (finddisplay 24 displayctrl 101))exitWith{
				true
			};
			pvpfw_chatString = (ctrlText (finddisplay 24 displayctrl 101));
			false
		};
	};
},"pvpfw_handle_chatIntercept"] call pvpfw_fnc_spawn;
