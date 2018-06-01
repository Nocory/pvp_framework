"pvpfw_pv_missionFlow_endMission" addPublicVariableEventHandler {
	_varName = _this select 0;
	_varValue = _this select 1;
	
	_varValue spawn pvpfw_fnc_missionFlow_clientShowOutro;
};

pvpfw_fnc_missionFlow_clientShowOutro = {
	_casBlu = param [0,-1];
	_casRed = param [1,-1];
	_objBlu = param [2,-1];
	_objRed = param [3,-1];
	
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