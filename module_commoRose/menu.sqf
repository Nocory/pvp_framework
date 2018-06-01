
if (!pvpfw_initialized)then{
	waitUntil{pvpfw_initialized};
};

//////////////////////
// INITIALIZE PAGES //
//////////////////////

// Identifier and condition to show the page
pvpfw_commoRose_initializedPages = [
	["Page_Interactions",{true},"Interactions"],
	["Page_Default",{true},"Main"],
	["Page_Training",{pvpfw_param_trainingEnabled == 1 || pvpfw_playerIsAdmin},"Training Tools","#aaffff"],
	["Page_SettingsAndDebug",{true},"Settings & Debug"]
];

//////////
// TEST //
//////////

/*
["","Page_Test","Test",{
	[] call pvpfw_fnc_core_teleport;
}] call pvpfw_fnc_commoRose_addEntry;
*/

////////////////
// CONTEXTUAL //
//   CENTER   //
////////////////

[
	"stop cnstr ident","Page_Default","Stop Constr.",
	{[] call pvpfw_fnc_constr_stopConstruction},
	"#ffaaaa",
	{(["pvpfw_fnc_constr_clickedBuild","onEachFrame"] call pvpfw_fnc_cse_inStacked) || (["pvpfw_fnc_constr_clickedReclaim","onEachFrame"] call pvpfw_fnc_cse_inStacked)},
	97
] call pvpfw_fnc_commoRose_addContextual;


[
	"deploy cv ident","Page_Default","Deploy CV",
	{
		_vehicle = vehicle player;
		if (_vehicle getVariable ["pvpfw_CVDeployStatus",0] == 0) then{
			_vehicle setVariable["pvpfw_CVDeployStatus",1,true];
			pvpfw_wargames_pv_CVDeployed = [_vehicle,1];
			publicVariable "pvpfw_wargames_pv_CVDeployed";
			pvpfw_wargames_pv_CVDeployed call pvpfw_wargames_CVDeployed;
		};
	},
	"#aaffaa",
	{player == driver (vehicle player) && {(vehicle player) getVariable ["pvpfw_vehicleisCV",false]} && {!(isEngineOn (vehicle player))} && {(vehicle player) getVariable ["pvpfw_CVDeployStatus",0] == 0}},
	99
] call pvpfw_fnc_commoRose_addContextual;

[
	"exit uav ident","Page_Default","Exit UAV",
	{
		[] call pvpfw_fnc_commoRose_close;
		pvpfw_uav_active = false;
	},
	"#aaffaa",
	{pvpfw_uav_active},
	97
] call pvpfw_fnc_commoRose_addContextual;

[
	"cv uav ident","Page_Default","CV UAV",
	{
		[] call compile preProcessFilelineNumbers "module_uav\init.sqf";
		[] call pvpfw_fnc_commoRose_close;
		[] spawn pvpfw_fnc_uav_circleObserver;
	},
	"#aaffaa",
	{((vehicle player) getVariable ["pvpfw_vehicleIsCV",false]) && (player == commander (vehicle player))},
	97
] call pvpfw_fnc_commoRose_addContextual;

///////////////////
// TRAINING PAGE //
///////////////////

["","Page_Training","Teleport",{
	[] call pvpfw_fnc_core_teleport;
}] call pvpfw_fnc_commoRose_addEntry;

//["","Page_Training","Landing Benchmark",{[] call pvpfw_training_initiateLandingBenchmark;}] call pvpfw_fnc_commoRose_addEntry;

["","Page_Training","Camera Mode",
	[
		["A2 Camera",{
			[] call pvpfw_fnc_commoRose_close;
			player call BIS_fnc_cameraOld;
		}],
		["A3 Camera",{
			[] call pvpfw_fnc_commoRose_close;
			[] call bis_fnc_camera;
		}]
	],
	"#ffffff"
] call pvpfw_fnc_commoRose_addEntry;
/*
["","Page_Training","Projectile Tracing",
	[
		["On Player",{[vehicle player, nil, nil, 2, nil, nil, true] call hyp_fnc_traceFire;}],
		["On Cursortarget",{[cursorTarget, nil, nil, 2, nil, nil, true] call hyp_fnc_traceFire;}],
		["Clear Lines",{{[_x] call hyp_fnc_traceFireClear}forEach hyp_var_tracer_tracedUnits;}],
		["Stop Tracing",{{[_x] call hyp_fnc_traceFireRemove}forEach hyp_var_tracer_tracedUnits;}]
	],
	"#aaaaff"
] call pvpfw_fnc_commoRose_addEntry;
*/
["","Page_Training","Change Weather",
	[
		["Clear",{[[[1],"module_weather\init.sqf"],"pvpfw_fnc_spawn",false] call BIS_fnc_MP;}],
		["Cloudy",{[[[2],"module_weather\init.sqf"],"pvpfw_fnc_spawn",false] call BIS_fnc_MP;}],
		["Overcast",{[[[3],"module_weather\init.sqf"],"pvpfw_fnc_spawn",false] call BIS_fnc_MP;}],
		["Light Rain",{[[[4],"module_weather\init.sqf"],"pvpfw_fnc_spawn",false] call BIS_fnc_MP;}],
		["Moderate Rain",{[[[5],"module_weather\init.sqf"],"pvpfw_fnc_spawn",false] call BIS_fnc_MP;}],
		["Heavy Rain",{[[[6],"module_weather\init.sqf"],"pvpfw_fnc_spawn",false] call BIS_fnc_MP;}],
		["Storm",{[[[7],"module_weather\init.sqf"],"pvpfw_fnc_spawn",false] call BIS_fnc_MP;}],
		["Light Fog",{[[[8],"module_weather\init.sqf"],"pvpfw_fnc_spawn",false] call BIS_fnc_MP;}],
		["Moderate Fog",{[[[9],"module_weather\init.sqf"],"pvpfw_fnc_spawn",false] call BIS_fnc_MP;}],
		["Thick Fog",{[[[10],"module_weather\init.sqf"],"pvpfw_fnc_spawn",false] call BIS_fnc_MP;}]
	],
	"#ffffff"
] call pvpfw_fnc_commoRose_addEntry;

["","Page_Training","Open Arsenal",
	{
		[] call pvpfw_fnc_commoRose_close;
		["Open",true] spawn BIS_fnc_arsenal
	},
	"#ffffff"
] call pvpfw_fnc_commoRose_addEntry;


//////////////////
// DEFAULT PAGE //
//////////////////

[
	"","Page_Default","Choose Markercolor",
	[
		["Black",{[1] call pvpfw_fnc_markers_setMarkerColor}],
		["Blue",{[2] call pvpfw_fnc_markers_setMarkerColor}],
		["Green",{[3] call pvpfw_fnc_markers_setMarkerColor}],
		["Orange",{[4] call pvpfw_fnc_markers_setMarkerColor}],
		["Yellow",{[5] call pvpfw_fnc_markers_setMarkerColor}],
		["Purple",{[6] call pvpfw_fnc_markers_setMarkerColor}]
	],
	"#ffffff"
] call pvpfw_fnc_commoRose_addEntry;

[
	"","Page_Default","Arm Self-Destruct",
	{
		[] call pvpfw_selfdestruct_arm;
	},
	"#ff0000",
	{player != vehicle player && player == driver vehicle player && !isEngineOn vehicle player && !((vehicle player) getVariable["pvpfw_selfdestruct_active",false])}
] call pvpfw_fnc_commoRose_addEntry;

[
	"","Page_Default","Disarm Self-Destruct",
	{
		[] call pvpfw_selfdestruct_disarm;
	},
	"#ff0000",
	{(vehicle player) getVariable["pvpfw_selfdestruct_active",false]}
] call pvpfw_fnc_commoRose_addEntry;

//////////////////////////
// PLAYER-TYPE SPECIFIC //
//////////////////////////

[
	"","Page_Default","Artillery Interface",
	{
		[] call pvpfw_fnc_commoRose_close;
		//[] spawn pvpfw_arty_openDialog
		[] spawn{
			showCommandingMenu "";
			waitUntil{commandingMenu == ""};
			if (!isMultiplayer)then{[] call compile preProcessFileLineNumbers "module_artillery\init.sqf";};
			[] spawn pvpfw_fnc_arty_openMain;
		};
	},
	"#ffffff",
	{true},
	{pvpfw_param_trainingEnabled == 1 || {typeOf player in ["O_officer_F","B_officer_F"]} || {pvpfw_playerIsAdmin} || {!isMultiplayer}}
] call pvpfw_fnc_commoRose_addEntry;

[
	"","Page_Default","Constr. Interface",
	{
		[] call pvpfw_fnc_commoRose_close;
		["pvpfw_chooseBuild","onEachFrame"] call BIS_fnc_removeStackedEventHandler;
		["pvpfw_chooseReclaim","onEachFrame"] call BIS_fnc_removeStackedEventHandler;
		[] spawn{
			showCommandingMenu "";
			waitUntil{commandingMenu == ""};
			if (!isMultiplayer)then{[] call compile preProcessFileLineNumbers "module_wargames\module_assets\construction\init.sqf";};
			[] spawn pvpfw_fnc_constr_openDialog;
		};
	},
	"#ffffff",
	{true},
	{pvpfw_param_trainingEnabled == 1 || {playerSide in [civilian,independent]} || {pvpfw_playerIsAdmin} || {!isMultiplayer}}
] call pvpfw_fnc_commoRose_addEntry;

[
	"","Page_Default","Repairs (admin)",
	{
		[] call pvpfw_fnc_commoRose_close;
		[] call compile preProcessFilelineNumbers "module_repairs\init.sqf";
	},
	"#ffffff",
	{pvpfw_playerIsAdmin && {cursorTarget isKindOf "Car" || cursorTarget isKindOf "Air"} && {player == vehicle player}},
	{pvpfw_playerIsAdmin}
] call pvpfw_fnc_commoRose_addEntry;

//////////////////
// LOW PRIORITY //
//////////////////

[
	"","Page_Default","Vehicle Service",
	{
		[] spawn pvpfw_fnc_vehService_startService;
	},
	"#ffffff",
	{(player == (driver (vehicle player))) && !(isEngineOn (vehicle player))}
] call pvpfw_fnc_commoRose_addEntry;

////////////////
// DEBUG PAGE //
////////////////

[
	"","Page_SettingsAndDebug","Debug Tools",
	[
		["Show/Hide FPS",{
			_terminated = ["pvpfw_fnc_perf_monitorClient"] call pvpfw_fnc_terminate;
			if (_terminated) exitWith{};
			[[],pvpfw_fnc_perf_monitorClient] call pvpfw_fnc_spawn;
		}]
	],
	"#ffffff"
] call pvpfw_fnc_commoRose_addEntry;

[
	"","Page_SettingsAndDebug","Terrain Detail",
	[
		["High",{
			setTerrainGrid 3.125;
			["Terraingrid: 3.125",2] call pvpfw_fnc_log_show;
		}],
		["Medium",{
			setTerrainGrid 6.25;
			["Terraingrid: 6.25",2] call pvpfw_fnc_log_show;
		}],
		["Low",{
			setTerrainGrid 12.5;
			["Terraingrid: 12.5",2] call pvpfw_fnc_log_show;
		}]
	],
	"#ffffff"
] call pvpfw_fnc_commoRose_addEntry;

[
	"","Page_SettingsAndDebug","Task Force Radio",
	[
		["Toggle On/Off",{
			if (pvpfw_param_trainingEnabled == 1)then{
				pvpfw_tfr_enabled = !pvpfw_tfr_enabled;
				["pvpfw_tfr_enabled",2] call pvpfw_fnc_log_show;
			}else{
				systemChat "==================================";
				systemChat "Can't toogle TFR during a battle";
				systemChat "==================================";
			};
		}],
		["Toggle Names",{
			pvpfw_tfr_whoIsTalkingEnabled = !pvpfw_tfr_whoIsTalkingEnabled;
			["pvpfw_tfr_whoIsTalkingEnabled",2] call pvpfw_fnc_log_show;
		}]
	],
	"#ffffff"
] call pvpfw_fnc_commoRose_addEntry;

[
	"","Page_SettingsAndDebug","Unflip Vehicle",pvpfw_fnc_core_unflip
] call pvpfw_fnc_commoRose_addEntry;

[
	"","Page_SettingsAndDebug","Commo-Rose Key",
	[
		["Hold key to open",{
			pvpfw_commoRose_holdKeyToOpen = true;
			profileNamespace setVariable ["pvpfw_commoRose_holdKeyToOpen",true];
			saveProfileNamespace;
		}],
		["Tap key to open",{
			pvpfw_commoRose_holdKeyToOpen = false;
			profileNamespace setVariable ["pvpfw_commoRose_holdKeyToOpen",false];
			saveProfileNamespace;
		}]
	]
] call pvpfw_fnc_commoRose_addEntry;

[
	"","Page_SettingsAndDebug","Debug Level",
	[
		["0 (Default)",{
			pvpfw_logLevel = 0;
			profileNamespace setVariable ["pvpfw_logLevel",pvpfw_logLevel];
			saveProfileNamespace;
			["pvpfw_logLevel",0] call pvpfw_fnc_log_show;
		}],
		["1",{
			pvpfw_logLevel = 1;
			profileNamespace setVariable ["pvpfw_logLevel",pvpfw_logLevel];
			saveProfileNamespace;
			["pvpfw_logLevel",0] call pvpfw_fnc_log_show;
		}],
		["2",{
			pvpfw_logLevel = 2;
			profileNamespace setVariable ["pvpfw_logLevel",pvpfw_logLevel];
			saveProfileNamespace;
			["pvpfw_logLevel",0] call pvpfw_fnc_log_show;
		}],
		["3",{
			pvpfw_logLevel = 3;
			profileNamespace setVariable ["pvpfw_logLevel",pvpfw_logLevel];
			saveProfileNamespace;
			["pvpfw_logLevel",0] call pvpfw_fnc_log_show;
		}]
	]
] call pvpfw_fnc_commoRose_addEntry;