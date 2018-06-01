
//other asset modules expect the funds module to be initialized first
[] call compile preprocessFileLineNumbers "module_wargames\module_assets\funds\init.sqf";

[] call compile preprocessFileLineNumbers "module_wargames\module_assets\construction\init.sqf";
[] call compile preprocessFileLineNumbers "module_wargames\module_assets\vehicles\init.sqf";

[] call compile preprocessFileLineNumbers "module_wargames\module_assets\equipment\init.sqf";
