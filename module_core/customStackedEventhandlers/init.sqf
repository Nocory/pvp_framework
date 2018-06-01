pvpfw_cse_reportOnFramePerfEvery = 5; // after how many seconds a performance calculation should be done
pvpfw_cse_nextPerfReport = diag_tickTime + pvpfw_cse_reportOnFramePerfEvery;
pvpfw_cse_msPerFrame = 0; // average ms per frame taken up by the onEachFrame calculations
pvpfw_cse_msTotal = 0;
pvpfw_cse_msCount = 0;

pvpfw_cse_suspendAll = false;

BIS_fnc_addStackedEventHandler = compile preProcessFileLineNumbers "module_core\customStackedEventhandlers\addStacked.sqf";
BIS_fnc_executeStackedEventHandler = compile preProcessFileLineNumbers "module_core\customStackedEventhandlers\execStacked.sqf";
BIS_fnc_removeStackedEventHandler = compile preProcessFileLineNumbers "module_core\customStackedEventhandlers\removeStacked.sqf";
pvpfw_fnc_cse_inStacked = compile preProcessFileLineNumbers "module_core\customStackedEventhandlers\inStacked.sqf";

onEachFrame {["oneachframe", []] call BIS_fnc_executeStackedEventHandler;};
// debug
/*
if (!isMultiplayer) then{
	[] spawn{
		waitUntil{sleep 0.1;alive player};
		player addEventhandler ["Fired",{
			pvpfw_cse_suspendAll = !pvpfw_cse_suspendAll;
		}];
	};
};
*/