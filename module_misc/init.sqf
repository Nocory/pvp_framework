if (isDedicated) exitWith{};

//[] execVM "module_misc\nightvision.sqf";
//[] execVM "module_misc\parachutes.sqf";

//Fatigue System *tweak*
[[],{
	scriptName "pvpfw_tweakFatigue";
	while{true}do{
		waituntil {sleep 0.19;damage player <0.1};
		player setFatigue 0;
		player enableFatigue false;
		waituntil {sleep 0.19;damage player >=0.1};
		player enableFatigue true;
	};
},"fatigue tweak"] call pvpfw_fnc_spawnOnce;

//Prevents player from being considered an enemy after an accidental teamkill
player addRating 10000000;
player removeEventHandler ["Respawn", missionNamespace getVariable["pvpfw_misc_respawnEH",-1]];
pvpfw_misc_respawnEH = player addEventhandler["Respawn",{
	player addRating 10000000;
}];
