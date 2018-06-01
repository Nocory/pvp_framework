/****************************************
Description:
Core module, with functions and features used by several other scripts.
It also controls menus and the mission presentation.
****************************************/

[] call compile preProcessFileLineNumbers "module_core\commonArrays\init.sqf";
[] call compile preProcessFileLineNumbers "module_core\commonFunctions\init.sqf";
[] call compile preProcessFileLineNumbers "module_core\scriptMonitor\init.sqf";
[] call compile preProcessFileLineNumbers "module_core\log\init.sqf";
[] call compile preProcessFileLineNumbers "module_core\customStackedEventhandlers\init.sqf";
[] call compile preProcessFileLineNumbers "module_core\customKeyEventhandlers\init.sqf";
[] call compile preProcessFileLineNumbers "module_core\hints\init.sqf";
[] call compile preProcessFileLineNumbers "module_core\stats\init.sqf";
[] call compile preProcessFileLineNumbers "module_core\events\init.sqf";
