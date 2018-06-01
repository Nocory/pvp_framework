// initialize your pages here
/*
	0: Unique identifier of the page
	1: Condition to show the page button to the player
	2: Page button text (Will use the page identifier if not specified)
	3:
*/
pvpfw_commoRose_initializedPages = [
	["Page_Default",{true},"Default Stuff"],
	["Page_Extra",{alive player},"Extra Page","#77ff77"],
	["Page_oneMore",{true},"Another Entry"]
];

////////////////
// CONTEXTUAL //
//   CENTER   //
////////////////

[
	"stop cnstr ident","Page_Default","Test 1",
	{systemChat "111"},
	"#ffaaaa",
	{true}
] call pvpfw_fnc_commoRose_addContextual;

[
	"stop cnstr identa","Page_Default","Test 2",
	{systemChat "222"},
	"#ffaaaa",
	{true}
] call pvpfw_fnc_commoRose_addContextual;

// max 8 entries per page at the moment
/*
	0: Unique identifier (can be "" if you dont need to remove the entry later)
	1: Page to add the entry to
	2: Button text
	3: Code or Array. Code will simply perform the action specified, while an array will open a sub-menu with further options.
	4: Color-Code ("#ffffff" if not specified)
	5: Condition to Show the button to the player ({True} if not specified)
	6: Condition that has to be true for the entry to be added to the menu at all
*/

[
	"","Page_Default","Teams",
	{
		[] call pvpfw_fnc_commoRose_close;
		[] spawn{
			showCommandingMenu "";
			waitUntil{commandingMenu == ""};
			if (isNull (findDisplay 19202))then{
		    [[],pvpfw_fnc_wg_teams_openDialog,"pvpfw_fnc_wg_teams_openDialog"] call pvpfw_fnc_spawnOnce;
		  };
		};
	},
	"#ffffff",
	{true},
	{true}
] call pvpfw_fnc_commoRose_addEntry;

[
	"","Page_Default","Construction",
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
	{player getVariable["pvpfw_rank",""] in ["officer","opcom","admin"]},
	{true}
] call pvpfw_fnc_commoRose_addEntry;

[
	"","Page_Default","Vehicles",
	{
		[] call pvpfw_fnc_commoRose_close;
		[] spawn{
			showCommandingMenu "";
			waitUntil{commandingMenu == ""};
			if (!isMultiplayer)then{[] call compile preProcessFileLineNumbers "module_wargames\module_assets\vehicles\init.sqf";};
			[] spawn pvpfw_fnc_wg_assets_vehicles_openDialog;
		};
	},
	"#ffffff",
	{player getVariable["pvpfw_rank",""] in ["officer","opcom","admin"]},
	{true}
] call pvpfw_fnc_commoRose_addEntry;

[
	"","Page_Default","Full Arsenal",
	{
		[] call pvpfw_fnc_commoRose_close;
		["Open",true] spawn BIS_fnc_arsenal;
	},
	"#ffffff",
	{player getVariable["pvpfw_rank",""] == "admin" || !isMultiplayer},
	{true}
] call pvpfw_fnc_commoRose_addEntry;

[
	"","Page_Default","Limited Arsenal",
	{
		[] call pvpfw_fnc_commoRose_close;
		[] call pvpfw_wg_assets_equipment_openArsenal;
	},
	"#ffffff",
	{((player distance pvpfw_wg_assets_arsenalCrateBlu) min (player distance pvpfw_wg_assets_arsenalCrateRed)) < 200},
	{true}
] call pvpfw_fnc_commoRose_addEntry;
