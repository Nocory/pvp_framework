private["_markedBy","_marker","_markerPos","_markerText","_global"];

_markedBy = _this select 0;
_marker = _this select 1;
_markerPos = _this select 2;
_markerText = _this select 3;
_global = (markerColor _marker != "");

diag_log format["#PVPFW New Marker# By: %1, Pos: %2, Text: %3, Global: %4",name _markedBy,_markerPos,_markerText,_global];