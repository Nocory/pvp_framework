
/****************************************
*****************************************
***
*** Mission: PvP Framework
*** Author: Conroy
***
*** This framework was created for ArmA Wargames (arma-wargames.com)
***
*** Features are separated in different modules and work independently from each other.
*** Any module can be activated or deactivated without unintended side-effects.
***
*** "module_core" is the only module, that is required to be active at all times.
***
*** All modules and even the main init.sqf can be hot-reloaded during a mission.
*** Modules will reset their variables, scripts and inGame assets, so that they will not run twice.
***
*****************************************
****************************************/

#define callCompile [] call compile preProcessFileLineNumbers
#define logCall(MESSAGE) diag_log text format ["|=== %1 === %2",diag_tickTime,MESSAGE];

// Keybind to hot reload the mission in editor mode
// (ctrl + space)
["keyDown","pvpfw_reloadAll"] call pvpfw_fnc_EH_removeKeyEH;
if (!isMultiplayer)then{
	["keyDown","pvpfw_reloadAll",57,{
		["RELOADALL"] call compile preProcessFileLineNumbers "init.sqf";
	},{true},["ctrl"]] call pvpfw_fnc_EH_addKeyEH;

	if((param[0,"",[""]]) == "RELOADALL")then{
		systemChat "==================";
		systemChat format["Reloading all scripts | time: %1",diag_tickTime];
		systemChat "==================";
		diag_log text "";
		diag_log text "|==========================================================|";
		diag_log text "|=== A hot reload of the main init.sqf has been requested";
	};
};

if (hasInterface)then{
	//0 cutText ["","BLACK FADED" ,999];
};

/*
0 fadeSound 0;
0 fadeMusic 0;
0 fadeSpeech 0;
0 fadeRadio 0;
*/

pvpfw_initialized = false;

removeAllMissionEventHandlers "Draw3D"; //not sure if this is still necessary or if BI fixed those EH not being reset on missionstart

if (!isDedicated) then{
	waitUntil {!isNull player && isPlayer player};
};

diag_log text "|==========================================================|";
diag_log text format ["|=== Product version: %1",productVersion];
diag_log text "|=== init.sqf begins processing files now";
diag_log text "|==========================================================|";


callCompile "config.sqf";

// ** priority modules first **

//callCompile "module_missionFlow\init.sqf"; logCall("missionFlow")
callCompile "module_templates\init.sqf"; logCall("templates")
callCompile "module_commoRose\init.sqf"; logCall("commoRose")
callCompile "module_chatCommands\init.sqf"; logCall("chatCommands")

// Core gameplay modules

callCompile "module_performance\init.sqf"; logCall("performance")
//callCompile "module_destruction\init.sqf"; logCall("destruction")
//callCompile "module_respawn\init.sqf"; logCall("respawn")
//callCompile "module_security\init.sqf"; logCall("security")

// extra features

//callCompile "module_wargames\module_assets\construction\init.sqf"; logCall("construction")
callCompile "module_base\init.sqf"; logCall("base")
callCompile "module_identifyInfantry\init.sqf"; logCall("identInf")
callCompile "module_markers\init.sqf"; logCall("markers")
//callCompile "module_logistic\init.sqf"; logCall("logistic")
//callCompile "module_selfDestruction\init.sqf"; logCall("selfdestruct")
//callCompile "module_artillery\init.sqf"; logCall("arty")
callCompile "module_misc\init.sqf"; logCall("misc")
//callCompile "module_training\init.sqf"; logCall("training")
//callCompile "module_vehicleService\init.sqf"; logCall("vehicleService")
//callCompile "module_record\init.sqf"; logCall("record")
//callCompile "module_uav\init.sqf"; logCall("uav")
//[] execVM "module_weather\init.sqf"; logCall("weather")
callCompile "module_ambient\init.sqf"; logCall("ambient")
callCompile "module_wounding\init.sqf"; logCall("wounding")
//callCompile "module_infAwareness\init.sqf"; logCall("infAwareness")

// System
callCompile "module_wargames\init.sqf"; logCall("wargames")

diag_log text "|==========================================================|";
diag_log text format ["|=== Reached the end of the primary init.sqf"];
diag_log text "|==========================================================|";
diag_log text "";

pvpfw_initialized = true;
