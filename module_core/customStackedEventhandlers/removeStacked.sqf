/***************************************************************************************
****************************************************************************************
***** A modified version of the BIS stacked eventhandlers for improved performance *****
****************************************************************************************
****************************************************************************************/

/*
	Author: Nelson Duarte
	Modified By: Conroy
	
	Description:
	This function removed an item that is stacked
	
	Parameter(s):
	_this select 0:	STRING	- The unique ID of the item inside the stack
	_this select 1:	STRING	- The onXxx event handler
	
	Returns:
	BOOLEAN - TRUE if successfully removed, FALSE if not
*/
//Parameters
private ["_id", "_event"];
_id		= param [0,"",[""]];
_event	= param [1,"",[""]];

//Mission namespace id
private "_namespaceId";
_namespaceId = "BIS_stackedEventHandlers_";

//Mission namespace event
private "_namespaceEvent";
_namespaceEvent = _namespaceId + _event;

//Data
private "_data";
_data = missionNameSpace getVariable [_namespaceEvent, []];

//Data item index
private "_index";
_index = -1;

//Go through all event handler data and find the correct index
{
	//Item id
	private "_itemId";
	_itemId	= _x param [0,"",[""]];
	
	//Is this the correct one?
	if (_id == _itemId) exitWith {
		_index = _forEachIndex;
	};
} forEach _data;

//Make sure data item was found
if (_index != -1) then {
	//Item found, change data type of element to STRING so we can remove it
	_data set [_index, "REMOVE_PLEASE"];
	
	//Remove item
	_data = _data - ["REMOVE_PLEASE"];
	
	//Update global container
	missionNameSpace setVariable [_namespaceEvent, _data];
	
	//Return
	true;
} else {
	false;
};
