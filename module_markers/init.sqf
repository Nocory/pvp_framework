/****************************************
*****************************************

Module: Markers
Global-var-shortcut: markers

Description:
  Handles player and vehicle map-markers

*****************************************
****************************************/

if (isDedicated) exitWith{};

call compile preProcessFileLineNumbers "module_markers\config.sqf";
call compile preProcessFileLineNumbers "module_markers\deadUnits.sqf";
//call compile preProcessFileLineNumbers "module_markers\unitMarkers.sqf";
//call compile preProcessFileLineNumbers "module_markers\unitMarkersNew.sqf";
call compile preProcessFileLineNumbers "module_markers\unitMarkers.sqf";
//call compile preProcessFileLineNumbers "module_markers\markFortifications.sqf";
