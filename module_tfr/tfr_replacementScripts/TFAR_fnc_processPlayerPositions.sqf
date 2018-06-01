private["_ticksPerInterval","_processThisFrame"];

if (!pvpfw_tfr_enabled || isNull player) exitWith{};

_ticksPerInterval = tf_nearUpdateTime / ((diag_tickTime - pvpfw_tfr_lastUpdateTick) max 0.005);
_processThisFrame = (tf_nearPlayersCount / _ticksPerInterval) max 1;

tf_proceessExtraNear = (tf_proceessExtraNear % 1) + (_processThisFrame % 1);

if (!tf_allUnitsCheckDone) then{
	[_ticksPerInterval] call TFAR_fnc_getNearPlayers
};

for "_i" from 1 to ((floor _processThisFrame) + (floor tf_proceessExtraNear)) do{
	if (tf_nearPlayersIndex >= tf_nearPlayersCount) then{
		if (tf_allUnitsCheckDone)then{
			tf_allUnitsCheckDone = false;
			
			tf_nearPlayersArray = +tf_unitsToCalculate;
			
			tf_unitsToCalculate resize 0;
			
			tf_allUnitsArray = allUnits;
			tf_allUnitsCount = count tf_allUnitsArray;
			tf_allUnitsIndex = 0;
			
			tf_nearPlayersCount = count tf_nearPlayersArray;
			tf_nearPlayersIndex = 0;
			
			// Show Radio Units
			_control1 = ((uiNameSpace getVariable ["pvpfw_tfr_whoIsTalking",findDisplay 999999]) displayCtrl 1);
			if (isNull _control1)then{
				(["pvpfw_tfr_whoIsTalkingLayer"] call BIS_fnc_rscLayer) cutRsc ["pvpfw_tfr_whoIsTalking", "PLAIN"];
				_control1 = ((uiNameSpace getVariable ["pvpfw_tfr_whoIsTalking",findDisplay 999999]) displayCtrl 1);
			};
			if (pvpfw_tfr_whoIsTalkingEnabled)then{
				_control1 ctrlSetStructuredText parseText (format["<t align='right' shadow='2' size='%3' color='%2'>%1</t>",pvpfw_tfr_unitsInSameSRChannel,"#ffffff",1]);
			}else{
				_control1 ctrlSetStructuredText parseText "";
			};
			pvpfw_tfr_unitsInSameSRChannel = "";
			
			call TFAR_fnc_sendVersionInfo;
			
			if (pvpfw_logLevel >= 4)then{
				_cycleTime = diag_tickTime - pvpfw_tfr_lastCycle;
				systemChat format["DEBUG: TFR - %1 - longer: %2 - %3",diag_tickTime,_cycleTime > tf_nearUpdateTime,(([_cycleTime,3] call BIS_fnc_cutDecimals) - tf_nearUpdateTime) max 0];
				diag_log format["DEBUG: TFR - %1 - longer: %2 - %3",diag_tickTime,_cycleTime > tf_nearUpdateTime,(([_cycleTime,3] call BIS_fnc_cutDecimals) - tf_nearUpdateTime) max 0];
				//systemChat format["UPF: %1, PEN: %2",_processThisFrame,tf_proceessExtraNear];
				pvpfw_tfr_lastCycle = diag_tickTime;
			};
		};
	}else{
		[tf_nearPlayersArray select tf_nearPlayersIndex, true] call TFAR_fnc_sendPlayerInfo;
		tf_nearPlayersIndex = tf_nearPlayersIndex + 1;
	};
};

if (diag_tickTime > tf_nextFrequencyTick)then{
	call TFAR_fnc_sendFrequencyInfo;
	tf_nextFrequencyTick = diag_tickTime + 0.4;
};

pvpfw_tfr_lastUpdateTick = diag_tickTime;