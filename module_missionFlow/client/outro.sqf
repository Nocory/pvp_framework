pvpfw_fnc_core_initiateMissionEnding = {
	diag_log text "==========================";
	diag_log text "INITIATING MISSION ENDING";
	diag_log text "==========================";
	
	pvpfw_active = false;
	publicVariable "pvpfw_active";
	
	if (isDedicated) then{
		[] call pvpfw_fnc_perf_monitorResultsToRPT;
	};
	
	// Broadcast Array
	pvpfw_pv_core_clientEndMission = [
		pvpfw_stats_casInfBlu,
		pvpfw_stats_casInfRed,
		[(pvpfw_wargames_battleResultBlu + pvpfw_wargames_AOControlBlu),1] call BIS_fnc_cutDecimals,
		[(pvpfw_wargames_battleResultRed + pvpfw_wargames_AOControlRed),1] call BIS_fnc_cutDecimals
	];
	
	publicVariable "pvpfw_pv_core_clientEndMission";
	if (!isDedicated) then{
		pvpfw_pv_core_clientEndMission spawn pvpfw_fnc_core_clientShowOutro;
	};
	
	diag_log "=== ENDSTATS ===";
	diag_log pvpfw_pv_core_clientEndMission;
	diag_log "=== ENDSTATS ===";
};

"pvpfw_pv_core_clientEndMission" addPublicVariableEventHandler {
	_varName = _this select 0;
	_varValue = _this select 1; //[winner-side,ending-type]
	
	_varValue spawn pvpfw_fnc_core_clientShowOutro;
};

pvpfw_fnc_core_clientShowOutro = {
	_casBlu = [_this,0,-1] call BIS_fnc_param;
	_casRed = [_this,1,-1] call BIS_fnc_param;
	_objBlu = [_this,2,-1] call BIS_fnc_param;
	_objRed = [_this,3,-1] call BIS_fnc_param;
	
	pvpfw_core_outroText = "";
	pvpfw_core_newOutroText = false;

	_composeText = {
		{
			pvpfw_core_outroText = pvpfw_core_outroText + _x;
		}forEach _this;
		pvpfw_core_newOutroText = true;
	};
	
	0 fadeMusic 0;
	16 fadeMusic 0.5;
	playMusic ["EP1_Track12_CrudeOil", 14];
	//playMusic ["Short01_Defcon_Three", 0];
	//playMusic ["LeadTrack03_F_Bootcamp", 0];
	
	sleep 4.2;

	1 cutText ["","BLACK", 10];
	10 fadeSound 0;
	sleep 10;

	removeAllWeapons player;

	player enableSimulation false;
	player action ["engineOff", vehicle player];
	player action ["autoHover", vehicle player];
	(vehicle player) enableSimulation false;

	sleep 1;
	
	_duration = 32;
	
	_text = "<t size='0.5' shadow='2' color='#ffffffff'>" + "The Mission Has Been Completed." + "</t>";
	[_text,0,0.0,_duration,1,0,4] spawn BIS_fnc_dynamicText;
	sleep 4;
	
	_text = "" + 
	// Cas
	"<t size='0.5' shadow='2' color='#ffffffff'>" + "|=== Infantry Losses ===|<br/></t>" + 
	"<t size='0.5' shadow='2' color='#ff1F75FE'>" +  str(_casBlu) + "</t>" +
	"<t size='0.5' shadow='2' color='#ffffffff'>" +  "  ||  " + "</t>" +
	"<t size='0.5' shadow='2' color='#ffED1C24'>" +  str(_casRed) + "<br/><br/></t>" + 
	// Obj
	"<t size='0.5' shadow='2' color='#ffffffff'>" + "|=== Battle Result ===|<br/></t>" + 
	"<t size='0.5' shadow='2' color='#ff1F75FE'>" +  str(_objBlu) + "</t>" +
	"<t size='0.5' shadow='2' color='#ffffffff'>" +  "  ||  " + "</t>" +
	"<t size='0.5' shadow='2' color='#ffED1C24'>" +  str(_objRed) + "<br/><br/></t>";
	
	[_text,0,0.2,_duration - 4,1,0,5] spawn BIS_fnc_dynamicText;
	
	sleep 16;
	
	_text = "<t size='0.5' shadow='2' color='#ffffffff'>" + "Debrief starts now." + "</t>";
	[_text,0,0.9,_duration - 20,1,0,8] spawn BIS_fnc_dynamicText;
	
	sleep 12;
	6 fadeMusic 0;
	sleep 6.5;
	
	diag_log text ""; 
	diag_log text format["|===========================   END %1   ===========================|", missionName];
	diag_log text "";
	endMission "END1";
};