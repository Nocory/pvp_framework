/// ProcessPlayerPositions

pvpfw_tfr_lastUpdateTick = diag_tickTime;
tf_earliestNearCheck = diag_tickTime;
tf_nextVersionTick = diag_tickTime + 0.1;
tf_nextFrequencyTick = diag_tickTime + 0.2;
tf_nearUpdateTime = 0.25; //0.3

// Process extra units each frame
tf_proceessExtraNear = 0;
tf_processExtraAllUnits = 0;

// Near Units
tf_nearPlayersIndex = 0;
tf_nearPlayersArray = call TFAR_fnc_getNearPlayers;
tf_nearPlayersCount = count tf_nearPlayersArray;

// All Units
tf_allUnitsCheckDone = true;
tf_allUnitsArray = [];
tf_allUnitsIndex = 0;
tf_allUnitsCount = 0;

// UnitsToCalculate
tf_unitsToCalculate = [];
//tf_unitsToCalculateIndex = 0;

// Radio Units
pvpfw_tfr_unitsInSameSRChannel = "";

pvpfw_tfr_whoIsTalkingEnabled = true;

// Debug
pvpfw_tfr_lastCycle = diag_tickTime;

pvpfw_tfr_allNearPositions = [];
pvpfw_tfr_allNearPositionsFinal = [];