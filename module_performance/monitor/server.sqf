/****************************************
*****************************************

Module: Monitor
Global-var-shortcut: monitor
Author: Conroy

Description:

Logs the servers performance and playercount.

*****************************************
****************************************/

scriptName "pvpfw_perf_monitor";

if (!isServer) exitWith{};

private["_fps","_fpsMin","_playersNumber","_missionObjects","_i","_nextCheck"];

_fps = 0;
_fpsMin = 0;
_playersNumber = 0;
_missionObjects = 0;

_infoMarker = "";

if (pvpfw_perf_monitorServerInfoOnMap) then{
	_infoMarker = "pvpfw_monitor_marker_info";
	deleteMarkerLocal _infoMarker;
	_infoMarker = createMarker [_infoMarker, [500,-500]];
	_infoMarker setmarkerSize [0.5,0.5];
	_infoMarker setmarkerAlpha 0.67;
	_infoMarker setMarkerShape "ICON";
	_infoMarker setMarkerType "mil_box";
	_infoMarker setMarkerColor "colorWhite";
};

_nextCheck = floor diag_tickTime + pvpfw_perf_monitorServerCheckInterval;
_i = 1;

pvpfw_monitor_fpsArray = [];
pvpfw_monitor_fpsMinArray = [];
pvpfw_monitor_PlayersNumberArray = [];
pvpfw_monitor_missionObjects = [];

waitUntil {sleep 0.01; diag_tickTime > _nextCheck};

sleep (random 0.123);

while{true}do{
	_currentfps = diag_fps;
	_currentObjectCount = count allMissionObjects "All";
	_currentPlayers = playersNumber west + playersNumber east + playersNumber resistance + playersNumber civilian;

	sleep 0.1;

	if (pvpfw_perf_monitorServerInfoOnMap) then{
		_infoMarker setMarkerText format["Server -> FPS: %1 || Connected: %2(blu) + %3(opf) || Objects %4 || Scripts %5+%6 || onEachFrame %7ms",
		(round (_currentfps * 10)) / 10,
		playersNumber west,
		playersNumber east,
		_currentObjectCount,
		count pvpfw_scriptMonitor_activeScripts,
		count (missionNameSpace getVariable ["BIS_stackedEventHandlers_onEachFrame",[]]),
		pvpfw_cse_msPerFrame];
	};

	sleep 0.1;

	_fps = _fps + _currentfps;
	_fpsMin = _fpsMin + diag_fpsmin;
	_playersNumber = _playersNumber + _currentPlayers;
	_missionObjects = _missionObjects + _currentObjectCount;

	if (_i >= pvpfw_perf_monitorServerLogEveryX) then{
		pvpfw_monitor_fpsArray pushBack (round (_fps / pvpfw_perf_monitorServerLogEveryX));
		pvpfw_monitor_fpsMinArray pushBack (round (_fpsMin / pvpfw_perf_monitorServerLogEveryX));
		pvpfw_monitor_PlayersNumberArray pushBack (round (_playersNumber / pvpfw_perf_monitorServerLogEveryX));
		pvpfw_monitor_missionObjects pushback (round (_missionObjects / pvpfw_perf_monitorServerLogEveryX));
		_i = 1;
		_fps = 0;
		_fpsMin = 0;
		_playersNumber = 0;
		_missionObjects = 0;
	}else{
		_i = _i + 1;
	};
	waitUntil {sleep 0.08; diag_tickTime > _nextCheck};
	_nextCheck = floor diag_tickTime + pvpfw_perf_monitorServerCheckInterval;
};
