
ppEffectDestroy (missionNamespace getVariable["pvpfw_ppEffect_woundingHitDyn",-1]);
pvpfw_ppEffect_woundingHitDyn = ppEffectCreate ["dynamicBlur", 635];

ctrlDelete (uiNamespace getVariable["pvpfw_wounding_flashCtrl",controlNull]);
uiNamespace setVariable["pvpfw_wounding_flashCtrl",(findDisplay 46) ctrlCreate ["RscText", -1]];

//player removeEventHandler ["Fired", missionNamespace getVariable["pvpfw_wound_eh",-1]];
player removeEventHandler ["Hit", missionNamespace getVariable["pvpfw_wound_eh",-1]];
pvpfw_wound_eh = player addEventhandler["Hit",{
	addCamShake [10, 0.4, 20];

	terminate (missionNamespace getVariable["pvpfw_wound_eh_handle",scriptNull]);
	pvpfw_wound_eh_handle = [] spawn{
		disableSerialization;

		_wounding_flashCtrl = (uiNamespace getVariable["pvpfw_wounding_flashCtrl",controlNull]);

		_wounding_flashCtrl ctrlSetBackgroundColor [1,1,1,1];
		_wounding_flashCtrl ctrlSetPosition [safeZoneXAbs,safeZoneY,safeZoneWAbs,safeZoneH];
		_wounding_flashCtrl ctrlSetFade 0.5;
		_wounding_flashCtrl ctrlCommit 0;

		pvpfw_ppEffect_woundingHitDyn ppEffectAdjust [1];
		pvpfw_ppEffect_woundingHitDyn ppEffectCommit 0;
		pvpfw_ppEffect_woundingHitDyn ppEffectEnable true;

		_wounding_flashCtrl ctrlSetFade 1;
		_wounding_flashCtrl ctrlCommit 1;

		pvpfw_ppEffect_woundingHitDyn ppEffectAdjust [0];
		pvpfw_ppEffect_woundingHitDyn ppEffectCommit 2;
		waitUntil{ppEffectCommitted pvpfw_ppEffect_woundingHitDyn};
		pvpfw_ppEffect_woundingHitDyn ppEffectEnable false;
	};
}];
