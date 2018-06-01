/****************************************
Handles player and vehicle map-markers for ->dead<- units only
****************************************/

#define pvpfw_markers_infDeadMarker 15
#define pvpfw_markers_vehDeadMarker 45

// *** HOT-RELOAD CLEANUP BEGIN
["pvpfw_markers_markDead"] call pvpfw_fnc_terminate;
{deleteMarkerLocal (_x select 0);}forEach (missionNamespace getVariable["pvpfw_marker_deadUnitsMarkerArray",[]]);
// *** HOT-RELOAD CLEANUP END

pvpfw_marker_deadUnitsMarkerArray = [];

/*
[(getPosASL _unit),"mil_destroy",[0.5,0.5],"",20,45] call pvpfw_fnc_markers_createDeadUnitMarker;
*/

pvpfw_fnc_markers_createDeadUnitMarker = {
	_marker = param[0,""];
	_marker setMarkerTypeLocal param[1,"mil_warning_noshadow"];
	_marker setMarkerSizeLocal param[2,[0.5,0.5]];
	_marker setMarkerDirLocal param[4,0];
	_marker setMarkerColorLocal "ColorRed";

	pvpfw_marker_deadUnitsMarkerArray pushBack [_marker,diag_tickTime + param[3,10]];
};

[[],{
	scriptName "pvpfw_markers_markDead";

	while{true}do{
		{
			if (diag_tickTime > (_x select 1))then{
				deleteMarkerLocal (_x select 0);
				pvpfw_marker_deadUnitsMarkerArray set[_forEachIndex,objNull];
			};
			sleep 0.1;
		}forEach pvpfw_marker_deadUnitsMarkerArray;
		sleep 0.1;
		pvpfw_marker_deadUnitsMarkerArray = pvpfw_marker_deadUnitsMarkerArray - [objNull];
		sleep 0.1;
	};
},"pvpfw_markers_markDead"] call pvpfw_fnc_spawn;
