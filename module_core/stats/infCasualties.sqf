
if (hasInterface) then{
	[] spawn{
		sleep 1;
		waitUntil{!isNull player && alive player};
		player addEventHandler ["killed",{
			_deadUnit = _this select 0;
			_killer = _this select 1;

			pvpfw_pv_core_playerDied = [_deadUnit,_killer,playerSide];
			publicVariableServer "pvpfw_pv_core_playerDied";
		}];
	};
};

if (isServer)then{
	pvpfw_stats_casInfBlu = 0;
	pvpfw_stats_casInfRed = 0;
	pvpfw_stats_casInfInd = 0;
	pvpfw_stats_casInfCiv = 0;

	"pvpfw_pv_core_playerDied" addPublicVariableEventhandler {
		_varValue = _this select 1;

		_deadUnit = _varValue select 0;
		_killer = _varValue select 1;
		// TODO change this to new PV from player object
		_deadSide = _deadUnit getVariable["pvpfw_customSide",civilian];

		switch(_deadSide)do{
			case(blufor):{pvpfw_stats_casInfBlu = pvpfw_stats_casInfBlu + 1;};
			case(opfor):{pvpfw_stats_casInfRed = pvpfw_stats_casInfRed + 1;};
			case(independent):{pvpfw_stats_casInfInd = pvpfw_stats_casInfInd + 1;};
			//case(civilian):{pvpfw_stats_casInfCiv = pvpfw_stats_casInfCiv + 1;};
		};
	};
};
