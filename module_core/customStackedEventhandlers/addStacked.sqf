/***************************************************************************************
****************************************************************************************
***** A modified version of the BIS stacked eventhandlers for improved performance *****
****************************************************************************************
****************************************************************************************/


/*
	Original Author: Nelson Duarte
	Modified By: Conroy
	
	Description:
	This function adds a new item that will be stacked and called upon event handler selected has been executed
	
	Parameter(s):
	_this select 0:	STRING	- The unique ID of the item inside the stack
	_this select 1:	STRING	- The onXxx event handler to monitor and execute code upon
	_this select 2:	(STRING of Code) or CODE	- The function name to execute upon the event triggering (the default function only accepted a string of code here)
	
	Returns:
	STRING - The stacked item ID
*/
//Parameters
private ["_id", "_event", "_code","_arguments"];
_id			= param [0,""];
_event		= param [1,""];
_code		= param [2,{},["",{}]];
_arguments	= param [3,[]];

if (typeName _code == "STRING") then{
	_code = call compile _code;
};

//Supported event handlers
private "_supportedEvents";
_supportedEvents = ["oneachframe", "onpreloadstarted", "onpreloadfinished", "onmapsingleclick", "onplayerconnected", "onplayerdisconnected"];

//Validate event
if !(toLower _event in _supportedEvents) exitWith {
	//Error
	["Stack with ID (%1) could not be added because the Event (%2) is not supported or does not exist. Supported Events (%3)", _id, _event, _supportedEvents] call BIS_fnc_error;
};

//Mission namespace id
private "_namespaceId";
_namespaceId = "BIS_stackedEventHandlers_";

//Mission namespace event
private "_namespaceEvent";
_namespaceEvent = _namespaceId + _event;

//The data
private "_data";
_data = missionNameSpace getVariable [_namespaceEvent, []];

//The index
private "_index";
_index = -1;

//Go through all event handler data and find if id is already defined, if so, we override it
{
	//Item id
	private "_itemId";
	_itemId	= _x param [0,"",[""]];
	
	//Is this the correct one?
	if (_id == _itemId) exitWith {
		_index = _forEachIndex;
	};
} forEach _data;

//Is data related to event empty
//If so, we need to initialize it
switch (toLower _event) do {
	case "oneachframe" : { onEachFrame { ["oneachframe"] call BIS_fnc_executeStackedEventHandler; }; };
	case "onpreloadstarted" : { onPreloadStarted { ["onpreloadstarted"] call BIS_fnc_executeStackedEventHandler; }; };
	case "onpreloadfinished" : { onPreloadFinished { ["onpreloadfinished"] call BIS_fnc_executeStackedEventHandler; }; };
	case "onmapsingleclick" : { onMapSingleClick { ["onmapsingleclick"] call BIS_fnc_executeStackedEventHandler; }; };
	case "onplayerconnected" : { onPlayerConnected { ["onplayerconnected"] call BIS_fnc_executeStackedEventHandler; }; };
	case "onplayerdisconnected" : { onPlayerDisconnected { ["onplayerdisconnected"] call BIS_fnc_executeStackedEventHandler; }; };
};

//Add new item, or override old one with same id
if (_index == -1) then {
	//Add
	_data pushBack [_id,_event,_code,_arguments];
} else {
	//Override
	_data set [_index, [_id,_event,_code,_arguments]];
};

//Store in namespace
missionNameSpace setVariable [_namespaceEvent, _data];

//Log
["Stack has been updated with ID (%1) for Event (%2) executing Function (%3), Replaced: (%4)", _id, _event, _code, _index != -1] call BIS_fnc_logFormat;
//diag_log format["Stack has been updated with ID (%1) for Event (%2) executing Function (%3), Replaced: (%4)", _id, _event, _code, _index != -1];
[format["Added %1 to %2EH",_id,_event],2] call pvpfw_fnc_log_show;

//Return
_id;
