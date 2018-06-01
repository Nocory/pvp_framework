/****************************************
Description:

****************************************/

call compile preProcessFileLineNumbers "module_performance\config.sqf";
call compile preProcessFileLineNumbers "module_performance\monitor\init.sqf";

disableRemoteSensors false; //new in 1.52, should be pretty good for performance

if (pvpfw_perf_cleanUpEnable) then{
	[] call compile preProcessFileLineNumbers "module_performance\cleanup\init.sqf";
};
