
if (!hasInterface) exitWith{};

[] call compile preProcessFilelineNumbers "module_tfr\tfr_replacementScripts\config.sqf";
[] call compile preProcessFilelineNumbers "module_tfr\tfr_replacementScripts\initCustomVars.sqf";

{
	missionNamespace setVariable[_x,compile preProcessFileLinenumbers (format["module_tfr\tfr_replacementScripts\%1.sqf",_x])]
}forEach [
	"TFAR_fnc_calcTerrainInterception",
	"TFAR_fnc_getNearPlayers",
	"TFAR_fnc_preparePositionCoordinates",
	"TFAR_fnc_processPlayerPositions",
	"TFAR_fnc_processRespawn",
	"TFAR_fnc_sendFrequencyInfo",
	"TFAR_fnc_sendPlayerInfo",
	"TFAR_fnc_onSwTangentPressed",
	"TFAR_fnc_onSwTangentReleased",
	"TFAR_fnc_sendPlayerKilled"
];

TFAR_fnc_activeSwRadio = {
	private ["_result"];
	_result = nil;
	{	
		if (_x call TFAR_fnc_isRadio) exitWith {_result = _x};
		
	} count (assignedItems player);
	if (isNil "_result")then[{nil},{_result}];
};

["ArmA Wargames", "pvpfw_tfr_oc", ["TFR Command", ""], my_awesome_func, {}, [22, [false, false, false]]] call cba_fnc_addKeybind;
["ArmA Wargames", "pvpfw_tfr_1a", ["TFR ch. 1-A", ""], my_awesome_func, {}, [22, [false, false, false]]] call cba_fnc_addKeybind;
["ArmA Wargames", "pvpfw_tfr_1b", ["TFR ch. 1-B", ""], my_awesome_func, {}, [22, [false, false, false]]] call cba_fnc_addKeybind;
["ArmA Wargames", "pvpfw_tfr_1c", ["TFR ch. 1-C", ""], my_awesome_func, {}, [22, [false, false, false]]] call cba_fnc_addKeybind;
["ArmA Wargames", "pvpfw_tfr_2a", ["TFR ch. 2-A", ""], my_awesome_func, {}, [22, [false, false, false]]] call cba_fnc_addKeybind;
["ArmA Wargames", "pvpfw_tfr_2b", ["TFR ch. 2-B", ""], my_awesome_func, {}, [22, [false, false, false]]] call cba_fnc_addKeybind;
["ArmA Wargames", "pvpfw_tfr_2c", ["TFR ch. 2-C", ""], my_awesome_func, {}, [22, [false, false, false]]] call cba_fnc_addKeybind;
["ArmA Wargames", "pvpfw_tfr_3a", ["TFR ch. 3-A", ""], my_awesome_func, {}, [22, [false, false, false]]] call cba_fnc_addKeybind;
["ArmA Wargames", "pvpfw_tfr_3b", ["TFR ch. 3-B", ""], my_awesome_func, {}, [22, [false, false, false]]] call cba_fnc_addKeybind;
["ArmA Wargames", "pvpfw_tfr_3c", ["TFR ch. 3-C", ""], my_awesome_func, {}, [22, [false, false, false]]] call cba_fnc_addKeybind;

// Set custom EH on the player

waitUntil{sleep 1;!isNull player && isPlayer player};

player setVariable ["tf_receivingDistanceMultiplicator", 1, true];
player setVariable ["tf_sendingDistanceMultiplicator", 10, true];

player addEventHandler["Respawn",{
	player setVariable ["tf_receivingDistanceMultiplicator", 1, true];
	player setVariable ["tf_sendingDistanceMultiplicator", 10, true];
	
	{
		player setVariable[("pvpfw_tfr" + _x),nil,true];
	}forEach["_currentSRFreqMain","_currentSRFreqAdditional","_currentLRFreqMain","_currentLRFreqAdditional"];
}];

player addEventHandler["Killed",{
	_unit = _this select 0;
	
	if (backPack _unit in ["tf_rt1523g","tf_mr3000"])then{removeBackpack _unit};
	{_unit unlinkItem _x}forEach assignedItems _unit;
}];

// Set custom radio channel according tp what the server pv'd and start the customized onEachFrame EH

_initTime = diag_tickTime;
waitUntil{["processPlayerPositionsHandler","onEachFrame"] call pvpfw_fnc_cse_inStacked || {diag_tickTime > _initTime + 5}};
["processPlayerPositionsHandler", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
["Replacing TFR onEachFrame EH",2] call pvpfw_fnc_log_show;

pvpfw_tfr_resetMyRadios = {
	diag_log "SHORT";
	_srRadio = (call TFAR_fnc_activeSwRadio);
	diag_log "LONG";
	_lrRadio = if (call TFAR_fnc_haveLRRadio) then[{(call TFAR_fnc_activeLrRadio)},{nil}];
	
	switch(playerSide)do{
		case(blufor):{
			if (!isNil "_srRadio")then{
				[_srRadio, +tf_freq_west] call TFAR_fnc_setSwSettings;
			};
			
			if (!isNil "_lrRadio")then{
				[_lrRadio select 0, _lrRadio select 1, +tf_freq_west_lr] call TFAR_fnc_setLrSettings;
			};
		};
		case(opfor):{
			if (!isNil "_srRadio")then{
				[_srRadio, +tf_freq_east] call TFAR_fnc_setSwSettings;
			};
			
			if (!isNil "_lrRadio")then{
				[_lrRadio select 0, _lrRadio select 1, +tf_freq_east_lr] call TFAR_fnc_setLrSettings;
			};
		};
	};
};

[] spawn{
	sleep (2 + random 2);
	[] call pvpfw_tfr_resetMyRadios;
};


waitUntil{sleep 0.05;!isNil "tf_nearUpdateTime"};
tf_nearUpdateTime = 0.25;

call TFAR_fnc_sendVersionInfo;
//TFAR_fnc_processPlayerPositions = compile preProcessFilelineNumbers "module_tfr\tfr_replacementScripts\TFAR_fnc_processPlayerPositions.sqf";
["processPlayerPositionsHandler", "onEachFrame", TFAR_fnc_processPlayerPositions] call BIS_fnc_addStackedEventHandler;

// Spawn sripts to broadcast the players channel and always set a vehicles radio to his sides setting

[] spawn{
	waitUntil{sleep 0.1;!isNil "pvpfw_fnc_spawn"};
	[[],{
		scriptName "pvpfw_tfr_setFreqinVehicle";
		sleep 3;
		while{true}do{
			waitUntil{sleep 0.1;vehicle player != player && player == driver (vehicle player)};
			_radio = call TFAR_fnc_VehicleLR;
			if (count _radio != 0)then{
				
				(vehicle player) setVariable ["tf_side", playerSide, true];
				
				switch(playerSide)do{
					case(blufor):{
						[_radio select 0, _radio select 1, tf_freq_west_lr] call TFAR_fnc_setLrSettings;
						[_radio select 0, _radio select 1, tf_west_radio_code] call TFAR_fnc_setLrRadioCode;
					};
					case(opfor):{
						[_radio select 0, _radio select 1, tf_freq_east_lr] call TFAR_fnc_setLrSettings;
						[_radio select 0, _radio select 1, tf_east_radio_code] call TFAR_fnc_setLrRadioCode;
					};
				};
			};
			waitUntil{sleep 0.1;vehicle player == player || player != driver (vehicle player)};
		};
	},"pvpfw_tfr_setFreqinVehicle"] call pvpfw_fnc_spawn;
	
	// set frequency as var on player object to be checked by others
	[[],{
		scriptName "pvpfw_tfr_setFreqOnPlayer";
		
		sleep 3;
		
		_currentSRFreqMain = "-1";
		_currentSRFreqAdditional = "-1";
		_currentLRFreqMain = "-1";
		_currentLRFreqAdditional = "-1";
		
		while{true}do{
			
			_shortPlayerName = missionnamespace getVariable["pvpfw_markers_shortPlayerName",name player];
			
			// Get SR Freq
			if (!isNil "TF_saved_active_sw_settings")then{
				_currentSRChannelFrequencies = TF_saved_active_sw_settings select 2;
				
				_currentSRChannelMain = TF_saved_active_sw_settings select 0;
				_currentSRChannelAdditional = TF_saved_active_sw_settings select 5;
				
				_currentSRFreqMain = if (_currentSRChannelMain != -1) then[{_currentSRChannelFrequencies select _currentSRChannelMain},{_shortPlayerName}];
				_currentSRFreqAdditional = if (_currentSRChannelAdditional != -1) then[{_currentSRChannelFrequencies select _currentSRChannelAdditional},{_shortPlayerName}];
			}else{
				_currentSRFreqMain = _shortPlayerName;
				_currentSRFreqAdditional = _shortPlayerName;
			};
			
			// Get LR Freq
			if (!isNil "TF_saved_active_lr_settings")then{
				_currentLRChannelFrequencies = TF_saved_active_lr_settings select 2;
				
				_currentLRChannelMain = TF_saved_active_lr_settings select 0;
				_currentLRChannelAdditional = TF_saved_active_lr_settings select 5;
				
				_currentLRFreqMain = if (_currentLRChannelMain != -1) then[{_currentLRChannelFrequencies select _currentLRChannelMain},{_shortPlayerName}];
				_currentLRFreqAdditional = if (_currentLRChannelAdditional != -1) then[{_currentLRChannelFrequencies select _currentLRChannelAdditional},{_shortPlayerName}];
			}else{
				_currentLRFreqMain = _shortPlayerName;
				_currentLRFreqAdditional = _shortPlayerName;
			};
			
			// Check current freq against saved freq
			{
				_playerVarString = "pvpfw_tfr" + _x;
				
				_playerVar = player getVariable[_playerVarString,"DEFAULT"];
				_radioVar = call compile _x;
				
				//diag_log [_playerVarString,_playerVar,_radioVar];
				
				if (_playerVar != _radioVar)then{
					player setVariable[_playerVarString,_radioVar,true];
					[format["%1 is %2",_playerVarString,_radioVar],2] call pvpfw_fnc_log_show;
				};
				sleep 0.05;
			}forEach["_currentSRFreqMain","_currentSRFreqAdditional","_currentLRFreqMain","_currentLRFreqAdditional"];
			sleep 0.05;
		};
	},"pvpfw_tfr_setFreqOnPlayer"] call pvpfw_fnc_spawn;
};

// Test

TFAR_fnc_requestRadios = {
	private ["_radiosToRequest", "_variableName", "_responseVariableName", "_response"];

	waitUntil {
		if (!TF_radio_request_mutex) exitWith {TF_radio_request_mutex = true; true};
		false;
	};
	if (time - TF_last_request_time > 3) then {
		TF_last_request_time = time;
		_variableName = "radio_request_" + (getPlayerUID player) + str (player call BIS_fnc_objectSide);
		_radiosToRequest = _this call TFAR_fnc_radioToRequestCount;

		if ((count _radiosToRequest) > 0) then {
			missionNamespace setVariable [_variableName, _radiosToRequest];
			_responseVariableName = "radio_response_" + (getPlayerUID player) + str (player call BIS_fnc_objectSide);
			missionNamespace setVariable [_responseVariableName, nil];
			publicVariableServer _variableName;
			titleText [localize ("STR_wait_radio"), "PLAIN"];
			waitUntil {!(isNil _responseVariableName)};
			_response = missionNamespace getVariable _responseVariableName;
			
			diag_log format["DEBUG: %1",_response];
			
			if (typename _response == "ARRAY") then {
				{
					player addItem _x;
				} count _response;
				if ((count _response > 0) and (TF_first_radio_request)) then 
				{
					TF_first_radio_request = false;
					player assignItem (_response select 0);
				};
			}else{
				hintC _response;
			};
			titleText ["", "PLAIN"];
		};
		TF_last_request_time = time;
	};
	TF_radio_request_mutex = false;
};
