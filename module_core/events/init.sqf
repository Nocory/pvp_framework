pvpfw_events_allEvents = [];
pvpfw_events_counter = 0;

pvpfw_fnc_events_addEH = {
	_eventName 	= param [0,"",[""]];
	_code 		= param [1,{},[{}]];
	
	if (_eventName == "" || str(_code) == "{}") exitWith{
		["pvpfw_fnc_events_addEH undefined param",1] call pvpfw_fnc_log_show;
	};
	
	_arrayString = "pvpfw_events_array_" + _eventName;
	if (isNil _arrayString)then{
		missionNamespace setVariable[_arrayString,[]];
	};
	
	_eventArray = missionNamespace getVariable[_arrayString,[]];
	_eventArray pushback[str(pvpfw_events_counter),_code];
	
	// Debug
	[format["New event for '%1', ID %2",_eventName,pvpfw_events_counter],2] call pvpfw_fnc_log_show;
	
	// Increment event ID
	pvpfw_events_counter = pvpfw_events_counter + 1;
	
	// Return used ID
	(pvpfw_events_counter - 1)
};

pvpfw_fnc_events_removeEH = {
	_eventName 	= param [0,"",[""]];
	_ID 		= param [1,-1,[0]];
	
	_eventArray = missionNamespace getVariable["pvpfw_events_array_" + _eventName,[]];
	
	{
		if ((_x select 0) == _ID)exitWith{
			_eventArray deleteAt _forEachIndex;
		};
	}forEach _eventArray;
};

pvpfw_fnc_events_removeAllEH = {
	_eventName = param [0,"",[""]];
	missionNamespace setVariable["pvpfw_events_array_" + _eventName,[]];
};

pvpfw_fnc_events_callEH = {
	_eventName = _this select 0;
	_arguments = _this select 1;
	
	{
		_code = _x select 1;
		
		_arguments call _code;
	}forEach (missionnamespace getVariable[("pvpfw_events_array_" + _eventName),[]])
};