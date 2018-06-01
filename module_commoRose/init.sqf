/***************************
***
*** This module provides a commorose GUI when the specified key is pressed
*** Other scripts can create their own entries and sub-menus
***
***************************/

if (!hasInterface) exitWith{};

call compile preProcessFileLineNumbers "module_commoRose\config.sqf";
call compile preProcessFileLineNumbers "module_commoRose\functions.sqf";

pvpfw_fnc_commoRose_addContextual = compile preProcessFileLineNumbers "module_commoRose\functions\addContextual.sqf";
pvpfw_fnc_commoRose_addEntry = compile preProcessFileLineNumbers "module_commoRose\functions\addEntry.sqf";
pvpfw_fnc_commoRose_buttonClicked = compile preProcessFileLineNumbers "module_commoRose\functions\buttonClicked.sqf";
pvpfw_fnc_commoRose_showSubButtons = compile preProcessFileLineNumbers "module_commoRose\functions\showSubButtons.sqf";
pvpfw_fnc_commoRose_open = compile preProcessFileLineNumbers "module_commoRose\functions\open.sqf";
call compile preProcessFileLineNumbers "module_commoRose\functions\misc.sqf";

[] call compile preProcessFileLineNumbers "module_commoRose\example.sqf"; // actions get added to commorose GUI

pvpfw_commoRose_active = false;
pvpfw_commoRose_delayOpeningTill = missionNamespace getVariable["pvpfw_commoRose_delayOpeningTill",0];
pvpfw_commoRose_debugLastRecompile = missionNamespace getVariable["pvpfw_commoRose_debugLastRecompile",0];

pvpfw_commoRose_keyPressed = {
	if (!alive player || pvpfw_commoRose_active || diag_tickTime < pvpfw_commoRose_delayOpeningTill)exitWith{};

	if (!isMultiplayer && diag_tickTime > (pvpfw_commoRose_debugLastRecompile + 5)) exitWith{
		systemChat "recompiling rose";
		pvpfw_commoRose_debugLastRecompile = diag_tickTime;
		[] call compile preProcessFileLineNumbers "module_commoRose\init.sqf";
		[] call pvpfw_commoRose_keyPressed;
	};

	pvpfw_commoRose_active = true;
	["Page_Default",true] call pvpfw_fnc_commoRose_open;

	[[],{
		disableSerialization;
		waitUntil{!pvpfw_commoRose_active || isNull (uiNamespace getVariable['pvpfw_core_dialog',controlNull])};
		pvpfw_commoRose_active = false; // set to false, in case the menu was closed by pressing escape
		_display = uiNamespace getVariable['pvpfw_core_dialog',controlNull];
		if !(isNull _display)then{_display closeDisplay 0;};
	},"pvpfw_commoRose_monitor"] call pvpfw_fnc_spawn;
};

pvpfw_commoRose_keyLifted = {
	pvpfw_commoRose_active = false;
};

//["ArmA Wargames", "commoRose_open", ["Open Commo-Rose", "Tooltip goes here"], pvpfw_commoRose_keyPressed, {missionNamespace setVariable["pvpfw_commoRose_active",false]}, [22, [false, false, false]]] call cba_fnc_addKeybind;
//["keyDown","pvpfw_commoRose_pressed",219,{[] call pvpfw_commoRose_keyPressed}] call pvpfw_fnc_EH_addKeyEH;
//["keyUp","pvpfw_commoRose_lifted",219,{[] call pvpfw_commoRose_keyLifted}] call pvpfw_fnc_EH_addKeyEH;

["ArmA Wargames", "Open Commo-Rose", "Open Commo-Rose",{_this call pvpfw_commoRose_keyPressed},{_this call {missionNamespace setVariable["pvpfw_commoRose_active",false]}},
[219,[false,false,false]],false] call CBA_fnc_addKeybind;
