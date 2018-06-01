#define __pvpfw_log_liftKeyCombo _key == 219 && _ctrl //you can use the key id and _ctrl,_shift,_alt

pvpfw_log_lifters = ["O_Heli_Light_02_unarmed_F","I_Heli_Transport_02_F","AW_B_Heli_Transport_01_F","AW_O_Heli_Transport_01_F","I_Heli_light_03_unarmed_F","Cha_Mi17_Civilian"];
pvpfw_log_canBeLifted = ["Car"]; //class types, that can be lifted
pvpfw_log_excludeFromLifting = ["I_MBT_03_cannon_F","O_MBT_02_cannon_F","AW_B_APC_Tracked_01_rcws_F","AW_O_APC_Wheeled_02_rcws_F","Wheeled_APC"]; //class types to be excluded, even if they are part of pvpfw_log_canBeLifted

/*
pvpfw_log_canBeLifted = ["Car","Tank_F","Wheeled_APC","B_supplyCrate_F"];
pvpfw_log_excludeFromLifting = [];

publicVariable "pvpfw_log_canBeLifted";
publicVariable "pvpfw_log_excludeFromLifting";