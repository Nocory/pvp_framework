/*
[] execVM "module_markerIntercept\init.sqf";
*/

/*************************************************
**************************************************

Log and Change Markers
Author: Conroy

Description:
	This script module provides functionality for changing and logging user created markers.

Usage:
	include the cfgFunctions.hpp in your description.ext with any new function tag (ideally use pvpfw).
	
	description.ext example:
		class CfgFunctions
		{
			class pvpfw
			{
				#include "module_markerIntercept\cfgFunctions.hpp"
			};
		};
	
Script customization:

	See "module_markerIntercept\client\change.sqf" for changes, that are applied to markers depending on their text and
	"module_markerIntercept\server\init.sqf" for code, that is run serverside whenever a marker is created.
	
Known Issue:
	A player has to completely reconnect, when he wants to change slots in the mission.
	Changing a slot while staying connected will prevent the script from getting the correct marker. (If the user already placed previous ones)
**************************************************
*************************************************/

if (isServer) then{
	call compile preProcessFileLineNumbers "module_markerIntercept\server\init.sqf";
};

if (hasInterface) then{
	call compile preProcessFileLineNumbers "module_markerIntercept\config.sqf";
	[] execVM "module_markerIntercept\client\init.sqf";
};