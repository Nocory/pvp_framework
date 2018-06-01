
scriptName "pvpfw_missionFlow";

private["_initTime"];

_initTime = diag_tickTime;

if (pvpfw_param_trainingEnabled == 1 || pvpfw_param_missionDuration == -1) exitWith{};

waitUntil{sleep 0.29;diag_tickTime > (_initTime + pvpfw_param_missionDuration)};
["pvpfw_wg_mainServer"] call pvpfw_fnc_terminate;

//[] spawn pvpfw_fnc_core_initiateMissionEnding;