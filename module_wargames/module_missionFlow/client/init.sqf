pvpfw_wg_mf_status = missionNamespace getVariable["pvpfw_wg_mf_status",1];

"pvpfw_wg_mf_fadeLayer" cutText ["","BLACK" ,0.01];

if (!isMultiplayer)then{
  ["keyDown","pvpfw_wg_mf_advance"] call pvpfw_fnc_EH_removeKeyEH;
  ["keyDown","pvpfw_wg_mf_advance",0xC8,{
		pvpfw_wg_mf_status = pvpfw_wg_mf_status + 1;
    systemChat format["pvpfw_wg_mf_status now: %1",pvpfw_wg_mf_status];
	}] call pvpfw_fnc_EH_addKeyEH;

  ["keyDown","pvpfw_wg_mf_back"] call pvpfw_fnc_EH_removeKeyEH;
  ["keyDown","pvpfw_wg_mf_back",0xD0,{
		pvpfw_wg_mf_status = pvpfw_wg_mf_status - 1;
    systemChat format["pvpfw_wg_mf_status now: %1",pvpfw_wg_mf_status];
    ["RELOADALL"] call compile preProcessFileLineNumbers "init.sqf";
	}] call pvpfw_fnc_EH_addKeyEH;
};

waitUntil{pvpfw_wg_mf_status > 0};

// standby camera
if (pvpfw_wg_mf_status in [1,2] || (player getVariable ["pvpfw_customSide",civilian]) == civilian)then{
  [[],"module_wargames\module_missionFlow\client\1_camera.sqf","pvpfw_wg_mf_cameraPan"] call pvpfw_fnc_spawnOnce;
  waitUntil{sleep 0.1;pvpfw_wg_mf_status > 1};
};

// choose side
if (pvpfw_wg_mf_status == 2 || (player getVariable ["pvpfw_customSide",civilian]) == civilian)then{
  ppEffectDestroy (missionNamespace getVariable["pvpfw_wg_teams_ppLayer",-1]);
  pvpfw_wg_teams_ppLayer = ppEffectCreate ["dynamicBlur", 636];
  pvpfw_wg_teams_ppLayer ppEffectAdjust [1];
  pvpfw_wg_teams_ppLayer ppEffectCommit 4;
  pvpfw_wg_teams_ppLayer ppEffectEnable true;

  sleep 6;

  [[],"module_wargames\module_missionFlow\client\2_chooseSide.sqf","pvpfw_wg_mf_chooseSide"] call pvpfw_fnc_spawnOnce;
  waitUntil{sleep 0.1;pvpfw_wg_mf_status > 2 && (player getVariable ["pvpfw_customSide",civilian]) != civilian};
  "pvpfw_wg_mf_fadeLayer_2" cutText ["","BLACK" ,1];
  sleep 1;
};

// special step where we stop the camera panning and close the side menu and give control back to the player
["pvpfw_wg_mf_cameraPan"] call pvpfw_fnc_terminate;
["pvpfw_wg_mf_chooseSide"] call pvpfw_fnc_terminate;
[] call compile preprocessFileLineNumbers "module_wargames\module_missionFlow\client\1_camera_stop.sqf";
[] spawn compile preprocessFileLineNumbers "module_wargames\module_missionFlow\client\2_chooseSide_stop.sqf";
showCinemaBorder false;
//"pvpfw_wg_mf_fadeLayer_2" cutText ["","BLACK IN" ,1];
"pvpfw_wg_mf_fadeLayer_2" cutFadeOut 5;

// briefing
if (pvpfw_wg_mf_status == 3)then{
  [[],"module_wargames\module_missionFlow\client\3_briefing.sqf","pvpfw_wg_mf_briefing"] call pvpfw_fnc_spawnOnce;
  waitUntil{pvpfw_wg_mf_status > 3};
};

// intro
if (pvpfw_wg_mf_status == 4)then{
  [[],"module_wargames\module_missionFlow\client\3_briefing.sqf","pvpfw_wg_mf_intro"] call pvpfw_fnc_spawnOnce;
  waitUntil{sleep 0.1;pvpfw_wg_mf_status > 4};
};

// battle
pvpfw_wg_assets_vehicles_allowPurchase = true;
if (pvpfw_wg_mf_status == 5)then{
  [[],"module_wargames\module_missionFlow\client\5_battle.sqf","pvpfw_wg_mf_battle"] call pvpfw_fnc_spawnOnce;
  waitUntil{sleep 0.25;pvpfw_wg_mf_status > 5};
};

// outro
if (pvpfw_wg_mf_status == 6)then{
  //[[],"module_wargames\module_missionFlow\client\6_outro.sqf","pvpfw_wg_mf_outro"] call pvpfw_fnc_spawnOnce;
  [[],"module_wargames\module_missionFlow\client\6_outro_alt.sqf","pvpfw_wg_mf_outro"] call pvpfw_fnc_spawnOnce;
  waitUntil{sleep 0.25;pvpfw_wg_mf_status > 6};
};

// debrief
if (pvpfw_wg_mf_status == 7)then{

};
