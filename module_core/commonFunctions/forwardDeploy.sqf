_requestedPos = param [0,getPos player];

if (player distance (markerPos "pvpfw_red_camTarget") < 500 && player distance (markerPos "pvpfw_blu_camTarget") < 500) exitWith{
	onMapSingleClick ""
};

_sideString = switch(playerSide)do{
	case(blufor):{"blu"};
	case(opfor):{"red"};
	default{"blu"};
};

_bufferMarker = "pvpfw_wg_buffer_" + _sideString;

_inMarker = [_requestedPos,_bufferMarker] call pvpfw_fnc_core_inMarker;

if (_inMarker) then{
	_requestedPos spawn{
		(vehicle player) setPos _this;
		sleep 0.1;
		_dirTo = [(vehicle player),markerPos "pvpfw_obj_0"] call BIS_fnc_dirTo;
		(vehicle player) setDir _dirTo;
	};
}else{
	["pvpfw_default",["Aborting:","Requested position not inside the friendly buffer zone"]] call BIS_fnc_showNotification;
};