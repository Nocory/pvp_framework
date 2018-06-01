
pvpfw_constr_layer = "pvpfw_constr_layer" call bis_fnc_rscLayer;
pvpfw_handle_constr = [] spawn{true};

pvpfw_fnc_constr_openDialog = compile preprocessFileLineNumbers "module_wargames\module_assets\construction\client\openDialog.sqf";
pvpfw_fnc_constr_clickedBuild = compile preprocessFileLineNumbers "module_wargames\module_assets\construction\client\clickedBuild.sqf";
pvpfw_fnc_constr_clickedReclaim = compile preprocessFileLineNumbers "module_wargames\module_assets\construction\client\clickedReclaim.sqf";

pvpfw_fnc_constr_stopConstruction = compile preprocessFileLineNumbers "module_wargames\module_assets\construction\client\stopConstruction.sqf";

pvpfw_fnc_constr_sendObjectInfoToServer = compile preprocessFileLineNumbers "module_wargames\module_assets\construction\client\sendObjectInfoToServer.sqf";
pvpfw_fnc_constr_reclaim = compile preprocessFileLineNumbers "module_wargames\module_assets\construction\client\remove_single.sqf";

["ArmA Wargames", "Build/Reclaim Object", "Build/Reclaim Object",
{
	if (["pvpfw_fnc_constr_clickedBuild","onEachFrame"] call pvpfw_fnc_cse_inStacked)then{
		[] call pvpfw_fnc_constr_sendObjectInfoToServer;
	};
	if (["pvpfw_fnc_constr_clickedReclaim","onEachFrame"] call pvpfw_fnc_cse_inStacked)then{
		[] call pvpfw_fnc_constr_reclaim;
	};
},
"",
[219,[false,true,false]],false] call CBA_fnc_addKeybind;
