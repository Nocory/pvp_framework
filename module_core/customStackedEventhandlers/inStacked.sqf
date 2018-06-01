//Parameters
private ["_id","_event"];
_id 	= param [0,"NO_VALID_ID",[""]];
_event 	= param [1,"NO_VALID_EVENT",[""]];

//Mission namespace event
private "_namespaceEvent";
_namespaceEvent = "BIS_stackedEventHandlers_" + _event;

//Go through all event handler data and find the correct index
private "_index";
_index = -1;
{
	private "_itemId";
	_itemId	= _x param [0,"",[""]];
	
	if (_id == _itemId) exitWith {
		_index = _forEachIndex;
	};
}forEach (missionNameSpace getVariable [_namespaceEvent, []]);

//return
(_index != -1)