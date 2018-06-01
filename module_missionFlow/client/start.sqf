if (pvpfw_param_trainingEnabled == 1 && false) exitWith{
	4 fadeSound 1;
	4 fadeMusic 1;
	4 fadeSpeech 1;
	4 fadeRadio 1;
	pvpfw_playerReadyToMove = true;
};

4 cutText ["","BLACK FADED" ,9999]; //Set screen to black
player enableSimulation false;

if (isMultiplayer && false) then{
	0 fadeMusic 0;
	10 fadeMusic 0.34;
	playMusic "EventTrack01a_F_EPA";

	_duration = 10;

	_text = "<t size='0.8' font='PuristaMedium' shadow='2' color='#ffffffff'>" + "Take note:" + "</t>";
	[_text,0,0.1,_duration,1,0,6] spawn BIS_fnc_dynamicText;
	
	_text = "<t size='0.5' font='PuristaMedium' shadow='2' color='#ffffffff'>" +
	"Info 1 goes here" + "</t>";
	[_text,0,0.3,_duration,1,0,7] spawn BIS_fnc_dynamicText;
	
	_text = "<t size='0.5' font='PuristaMedium' shadow='2' color='#ffffffff'>" +
	"Info 2 goes here" + "</t>";
	[_text,0,0.45,_duration,1,0,8] spawn BIS_fnc_dynamicText;
	
	_text = "<t size='0.5' font='PuristaMedium' shadow='2' color='#ffffffff'>" +
	"Info 3 goes here" + "</t>";
	[_text,0,0.6,_duration,1,0,9] spawn BIS_fnc_dynamicText;
	
	sleep 10;
};

4 fadeSound 1;
4 fadeMusic 1;
4 fadeSpeech 1;
4 fadeRadio 1;
4 cutText ["","BLACK IN" ,4];
player enableSimulation true;
pvpfw_playerReadyToMove = true;

// TagCheck begin //

private["_tag","_match"];
_tag = (name player) select [0,3];

_match = switch(faction player)do{
	case("BLU_F"):{_tag == "[B]"};
	case("OPF_F"):{_tag == "[O]"};
	case("IND_F"):{_tag == "[I]"};
	case("CIV_F"):{_tag == "[C]"};
	default{false};
};

if (!_match && !pvpfw_playerIsAdmin) exitWith{
	CutText ["", "BLACK",9999];
	TitleText ["Your game tags are incorrect or you have joined the wrong side.", "BLACK",0];
	player setPosASL [-1000 + (random 500),-1000 + (random 500),5000 + (random 500)];
};

// TagCheck end //

player switchMove "AmovPercMstpSnonWnonDnon_Ease";

// Waiting screen

["ready",{
	if(pvpfw_playerIsAdmin)then{pvpfw_missionFlow_adminsReady = true; publicVariableServer "pvpfw_missionFlow_adminsReady"};
	if(pvpfw_playerIsBluforCommand)then{pvpfw_missionFlow_bluforReady = true; publicVariableServer "pvpfw_missionFlow_bluforReady"};
	if(pvpfw_playerIsOpforCommand)then{pvpfw_missionFlow_opforReady = true; publicVariableServer "pvpfw_missionFlow_opforReady"};
},{true}] call pvpfw_fnc_chatIntercept_addCommand;

if (pvpfw_missionFlow_secsTillStart == 0)exitWith{};

_xPos = 0.5 + safeZoneW * 0.25;
_yPos = 0.5 - safeZoneH * 0.2;
_yStep = safeZoneH * 0.02;	

waitUntil{
	sleep 0.01;
	
	//["<t size='0.5' font='PuristaMedium' shadow='2' color='#ffffffff' align='left'>Operation Commanders:<br/>Type <t underline='true'>!ready</t> in the chat to signal, that you are good to go.</t>",0,0.2,1,0,0,20] spawn BIS_fnc_dynamicText;
	
	[format["<t size='0.4' font='PuristaBold' shadow='2' color='#ffffffff' align='left'>BluFor: %1</t>",["<t color='#ffff8888'>Not Ready</t>", "<t color='#ff88ff88'>Ready</t>"] select pvpfw_missionFlow_bluforReady],_xPos,_yPos + _yStep * 0,1,0,0,21] spawn BIS_fnc_dynamicText;
	[format["<t size='0.4' font='PuristaBold' shadow='2' color='#ffffffff' align='left'>OpFor: %1</t>",["<t color='#ffff8888'>Not Ready</t>", "<t color='#ff88ff88'>Ready</t>"] select pvpfw_missionFlow_opforReady],_xPos,_yPos + _yStep * 1,1,0,0,22] spawn BIS_fnc_dynamicText;
	[format["<t size='0.4' font='PuristaBold' shadow='2' color='#ffffffff' align='left'>Admins: %1</t>",["<t color='#ffff8888'>Not Ready</t>", "<t color='#ff88ff88'>Ready</t>"] select pvpfw_missionFlow_adminsReady],_xPos,_yPos + _yStep * 2,1,0,0,23] spawn BIS_fnc_dynamicText;
	/*
	if (_firstRdyTime == -1 && pvpfw_missionFlow_adminsReady && (pvpfw_missionFlow_bluforReady || pvpfw_missionFlow_opforReady))then{
		_firstRdyTime = diag_tickTime;
		_endTime = _firstRdyTime + 20;
		
		0 fadeMusic 0;
		2 fadeMusic 0.5;
		playMusic ["BackgroundTrack04_F_EPC", 8];
		//playMusic ["BackgroundTrack01_F_EPB", 55];
	};
	*/
	if (pvpfw_missionFlow_secsTillStart < 121)then{
		[format["<t size='0.4' font='PuristaBold' shadow='2' color='#ffffffff' align='left'>Commencing in %1</t>",pvpfw_missionFlow_secsTillStart],_xPos,_yPos + _yStep * 3,1,0,0,24] spawn BIS_fnc_dynamicText;
	};
	
	pvpfw_missionFlow_secsTillStart == 0;
};

3 fadeMusic 0;

["<t size='0.4' font='PuristaBold' shadow='2' color='#ffffffff' align='left'>Commencing NOW</t>",_xPos,_yPos + _yStep * 3,1,0,-0.0,24] spawn BIS_fnc_dynamicText;

sleep 2;

// pre intro waiting done, now start the actual initial intro (same for mission starters and jips this time)
private["_allBlufor","_allOpfor"];
_allBlufor = [];
_allOpfor = [];
{
	switch(_x getVariable["pvpfw_customFaction",faction _x])do{
		case("BLU_F"):{_allBlufor pushBack (name _x)};
		case("OPF_F"):{_allOpfor pushBack (name _x)};
	};
}forEach allUnits;

systemChat str(_allBlufor);
systemChat str(_allOpfor);

playMusic "";
