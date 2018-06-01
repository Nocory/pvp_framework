["pvpfw_fnc_wg_teams_openDialog"] call pvpfw_fnc_terminate;
closeDialog 1;

_layer = missionNamespace getVariable["pvpfw_wg_teams_ppLayer",-1];

_layer ppEffectAdjust [0];
_layer ppEffectCommit 1;
waitUntil{ppEffectCommitted _layer};
_layer ppEffectEnable false;
ppEffectDestroy _layer;
