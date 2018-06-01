private["_initTime"];
_initTime = diag_tickTime;
waitUntil{(ctrlEnabled (findDisplay 54 displayCtrl 1)) || (diag_tickTime > (_initTime + 0.5))};
if !(ctrlEnabled (findDisplay 54 displayCtrl 1)) exitWith{systemChat "DEBUG: markerIntercept timed out";}; //times out if the player double clicks while holding shift for example

// If the directPlay ID has not yet been determined, then the script will place a marker and detect it.
if (isNil "pvpfw_mi_DPID")exitWith{
	(finddisplay 54 displayctrl 101) ctrlSetText pvpfw_mi_confCode;
	uiSleep 0.1;
	ctrlActivate (finddisplay 54 displayctrl 1);
	uiSleep 0.1;
	[] spawn pvpfw_fnc_mi_findDPID;
};

(findDisplay 54 displayCtrl 1) ctrlAddEventHandler ['ButtonClick', {
	[] spawn {
		private["_initTime","_markerString"];
		_initTime = diag_tickTime;

		_markerString = format["_USER_DEFINED #%1/%2/%3",pvpfw_mi_DPID,pvpfw_mi_markerCounter,currentChannel];

		waitUntil{markerColor _markerString != "" || (diag_tickTime > (_initTime + 5))};

		while{markerColor _markerString != ""}do{

		};

		uiSleep 0.1;

		pvpfw_mi_pv_receiveMarkerInfoClient = _markerString;
		publicVariable "pvpfw_mi_pv_receiveMarkerInfoClient";
		[_markerString,true] call pvpfw_fnc_mi_change;

		// inform the server, that we created a new marker
		pvpfw_pv_lacm_receiveMarkerInfoServer = [player,_markerString,markerPos _markerString,markerText _markerString];
		if (isServer)then{
			pvpfw_pv_lacm_receiveMarkerInfoServer call pvpfw_fnc_mi_handleMarkerOnServer
		}else{
			publicVariableServer "pvpfw_pv_lacm_receiveMarkerInfoServer";
		};

		pvpfw_mi_markerCounter = pvpfw_mi_markerCounter + 1;
	};
}];
