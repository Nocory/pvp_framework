["pvpfw_fnc_constr_clickedBuild","onEachFrame"] call BIS_fnc_removeStackedEventHandler;
["pvpfw_fnc_constr_clickedReclaim","onEachFrame"] call BIS_fnc_removeStackedEventHandler;

deleteVehicle (missionNamespace getVariable["pvpfw_constr_previewObject",objNull]);
deleteVehicle (missionNamespace getVariable["pvpfw_constr_helperObject",objNull]);

deleteVehicle (missionNamespace getVariable["pvpfw_constr_boundingHelper1",objNull]);
deleteVehicle (missionNamespace getVariable["pvpfw_constr_boundingHelper2",objNull]);

deleteVehicle (missionNamespace getVariable["pvpfw_constr_arrowObject",objNull]);

player removeAction (missionNamespace getVariable["pvpfw_constr_action_reclaimSpecial",-1]);

hintSilent "";