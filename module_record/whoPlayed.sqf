
if (!isServer) exitWith{
	[] spawn{
		waitUntil{sleep (1 + (random 1));!isNil "pvpfw_record_readyForParticipatingPlayers" && !isNil "pvpfw_markers_rawPlayerName"};
		pvpfw_record_playerIsParticipating = [getPlayerUID player,pvpfw_markers_rawPlayerName,name player,playerSide];
		publicVariableServer "pvpfw_record_playerIsParticipating";
	};
};

pvpfw_record_bluforPlayersUID = [];
pvpfw_record_opforPlayersUID = [];
pvpfw_record_bluforPlayersNames = [];
pvpfw_record_opforPlayersNames = [];

"pvpfw_record_playerIsParticipating" addPublicVariableEventhandler {
	_varValue = _this select 1;
	
	_uid = _varValue select 0;
	_rawName = _varValue select 1;
	_fullName = _varValue select 2;
	_side = _varValue select 3;
	
	switch(_side)do{
		case(blufor):{
			if !(_uid in pvpfw_record_bluforPlayersUID)then{
				pvpfw_record_bluforPlayersUID pushback _uid;
				pvpfw_record_bluforPlayersNames pushBack (_rawName + " --- " + _fullName);
			};
		};
		case(opfor):{
			if !(_uid in pvpfw_record_opforPlayersUID)then{
				pvpfw_record_opforPlayersUID pushback _uid;
				pvpfw_record_opforPlayersNames pushBack (_rawName + " --- " + _fullName);
			};
		};
	};
};

pvpfw_record_readyForParticipatingPlayers = true;
publicVariable "pvpfw_record_readyForParticipatingPlayers";