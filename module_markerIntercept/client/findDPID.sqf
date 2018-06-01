{
	if (markerText _x == pvpfw_mi_confCode) exitWith{
		_markerIDString = [_x,15] call BIS_fnc_trimString;
		_splitString = _markerIDString splitString "/";
		pvpfw_mi_DPID = _splitString select 0;
		pvpfw_mi_markerCounter = parseNumber (_splitString select 1);
		//deleteMarkerLocal "pvpfw_mi_initHint";
	};
}forEach allMapMarkers;

if (!isNil "pvpfw_mi_DPID") then{
	[(format["_USER_DEFINED #%1/%2/%3",pvpfw_mi_DPID,pvpfw_mi_markerCounter,currentChannel])] spawn{
		private["_marker"];
		_marker = _this select 0;
		_marker setMarkerTypeLocal "mil_dot";
		_marker setMarkerSizeLocal [0.5,0.5];
		_marker setMarkerColorLocal "ColorGreen";
		_marker setMarkerTextLocal "Initialized Markerscript Successfully";
		uisleep 2;
		deleteMarker _marker;
	};
	pvpfw_mi_markerCounter = pvpfw_mi_markerCounter + 1;
}else{
	systemChat "#WARNING#";
	systemChat "The marker-script is not initiliazed";
};
