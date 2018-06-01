
// Frequencies for the battles

tf_west_radio_code = "2CAB";
tf_east_radio_code = "5RCT";

tf_freq_west = [0,7,["72.3","79.8","54.3","66.6","73.7","74.2","67.7","37.5","51.5","56.3"],0,tf_west_radio_code,-1,0];
tf_freq_west_lr = [0,7,["145.6","169.2","105.8","179.6","139.2","107.7","180","130.4","179.7"],0,tf_west_radio_code,-1,0];

tf_freq_east = [0,7,["85.5","46.2","48.3","79.5","75.5","61.4","30.7","77.1","81.7","46.2"],0,tf_east_radio_code,-1,0];
tf_freq_east_lr = [0,7,["143.5","133.1","172.1","174.9","155.9","107.2","134.2","192.3","172.7"],0,tf_east_radio_code,-1,0];

if (hasInterface) then{
	diag_log format["playerSide: %1",playerSide];
	switch(playerSide)do{
		case(blufor):{
			TF_saved_active_sw_settings = tf_freq_west;
			TF_saved_active_lr_settings = tf_freq_west_lr;
		};
		case(opfor):{
			TF_saved_active_sw_settings = tf_freq_east;
			TF_saved_active_lr_settings = tf_freq_east_lr;
		};
	};
};

// Misc.

tf_no_auto_long_range_radio = true;
TF_give_personal_radio_to_regular_soldier = true;
TF_terrain_interception_coefficient = 0;

tf_same_sw_frequencies_for_side = true;
tf_same_lr_frequencies_for_side = true;

if (isServer)then{
	
	_nameAndPassword = switch(profileName)do{
		case("AW_Battle"):{["TFR_Battle","battle"]};
		case("AW_Blu"):{["TFR_Blufor","battle"]};
		case("AW_Red"):{["TFR_Opfor","battle"]};
		default{["no_channel","no_password"]};
	};
	
	tf_radio_channel_name = _nameAndPassword select 0;
	tf_radio_channel_password = _nameAndPassword select 1;
	publicVariable "tf_radio_channel_name";
	publicVariable "tf_radio_channel_password";
};