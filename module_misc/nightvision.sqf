if (isDedicated) exitWith{};

sleep 1;

private["_displayEventHandler","_allowedRoles"];

_allowedRoles = [
	"B_crew_F",
	"O_crew_F",
	"B_soldier_repair_F",
	"O_soldier_repair_F",
	"B_Helipilot_F",
	"O_helipilot_F",
	"B_sniper_F",
	"O_sniper_F",
	"B_spotter_F",
	"O_spotter_F"
];
if !((typeOf player) in _allowedRoles) exitWith{};

pvpfw_misc_NVActive = false;

pvpfw_ppEffect_NV = ppEffectCreate ["ColorCorrections", 2013];

pvpfw_ppEffect_NV ppEffectAdjust [1, 0.5, 0.002, [0.0, 0.0, 0.0, 0], [1.0, 1.0, 1.0, 0], [2, 2, 2, 1]];
pvpfw_ppEffect_NV ppEffectCommit 0;

pvpfw_misc_nvKeyPressed = {
	private["_handle"];
	if (!pvpfw_misc_NVActive && sunOrMoon < 1) then{
		pvpfw_ppEffect_NV ppEffectEnable true;
		setAperture 3;
		pvpfw_misc_NVActive = true;
		_handle = [] spawn {
			waitUntil{sleep 0.02;!pvpfw_misc_NVActive || (currentVisionMode player == 1)};
			pvpfw_ppEffect_NV ppEffectEnable false;
			setAperture -1;
		};
	}else{
		pvpfw_ppEffect_NV ppEffectEnable false;
		pvpfw_misc_NVActive = false;
		setAperture -1;
	};
};

["down","pvpfw_nightvision",[([actionKeys "NightVision",0,-1] call BIS_fnc_param),false,false,false],
	{
		private["_canUse"];
		_canUse = false;
		
		if (currentVisionMode player == 0) then{_canUse = true;};
		
		{
			if ((vehicle player) isKindOf _x) exitWith{_canUse = true;};
		}forEach ["Helicopter_Base_F","Plane_Base_F","Wheeled_APC_F","Tank_F"];
		_canUse
	},
	{[] call pvpfw_misc_nvKeyPressed}
] call pvpfw_fnc_EH_addKeyEH;