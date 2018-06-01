player removeEventHandler ["respawn", missionNamespace getVariable["pvpfw_respawn_clientKilledEH",-1]];
pvpfw_respawn_clientKilledEH = player addEventHandler ["killed",{
	_unit = _this select 0;
	_killer = _this select 1;

	//removeAllWeapons _unit;
	//removeAllAssignedItems _unit;

	titleText ["","BLACK OUT" ,6];

	6 fadeSound 0;
	6 fadeRadio 0;
	6 fadeSpeech 0;
}];

player removeEventHandler ["respawn", missionNamespace getVariable["pvpfw_respawn_clientRespawnEH",-1]];
pvpfw_respawn_clientRespawnEH = player addEventHandler ["respawn",{
	[player] joinSilent grpNull;

	[] spawn{
		sleep 0.5;

		_respawnMarker = format["pvpfw_respawn%1",player getVariable ["pvpfw_customSide",civilian]]
		player setPosATL (markerPos _respawnMarker);

		3 fadeSound 1;
		3 fadeRadio 1;
		3 fadeSpeech 1;

		sleep 1;

		titleText ["","BLACK IN" ,3];
	};
}];
