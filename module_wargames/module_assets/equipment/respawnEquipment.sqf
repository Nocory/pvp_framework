
_unit = param [0,player];
_side = _unit getVariable["pvpfw_customSide",civilian];
_isOpCom = _unit getVariable["pvpfw_isOpCom",false];

_equipArray = switch(_side)do{
	case(blufor):{[["arifle_MX_Black_F","","","",["30Rnd_65x39_caseless_mag",30],[],""],[],["hgun_P07_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_CombatUniform_mcam",[["FirstAidKit",1],["HandGrenade",1,2],["SmokeShell",1,1]]],["V_TacVest_oli",[["30Rnd_65x39_caseless_mag",30,6],["16Rnd_9x21_Mag",16,3]]],[],"H_Booniehat_khk","",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]]};
	case(opfor):{[["arifle_MX_Black_F","","","",["30Rnd_65x39_caseless_mag",30],[],""],[],["hgun_P07_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_CombatUniform_mcam",[["FirstAidKit",1],["HandGrenade",1,2],["SmokeShell",1,1]]],["V_TacVest_oli",[["30Rnd_65x39_caseless_mag",30,6],["16Rnd_9x21_Mag",16,3]]],[],"H_Booniehat_khk","",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]]};
	default{[["arifle_MX_Black_F","","","",["30Rnd_65x39_caseless_mag",30],[],""],[],["hgun_P07_F","","","",["16Rnd_9x21_Mag",16],[],""],["U_B_CombatUniform_mcam",[["FirstAidKit",1],["HandGrenade",1,2],["SmokeShell",1,1]]],["V_TacVest_oli",[["30Rnd_65x39_caseless_mag",30,6],["16Rnd_9x21_Mag",16,3]]],[],"H_Booniehat_khk","",[],["ItemMap","ItemGPS","ItemRadio","ItemCompass","ItemWatch",""]]};
};

player setUnitLoadout _equipArray;
