private ["_request","_result","_radioCount","_freq","_freq_lr","_freq_dd","_alive","_nickname","_isolated_and_inside","_can_speak","_depth","_globalVolume", "_voiceVolume", "_spectator", "_receivingDistanceMultiplicator"];

// send frequencies
/*
_isolated_and_inside = player call TFAR_fnc_vehicleIsIsolatedAndInside;
_depth = player call TFAR_fnc_eyeDepth;
_can_speak = [_isolated_and_inside, _depth] call TFAR_fnc_canSpeak;
*/
_isolated_and_inside = true;
_depth = 99;
_can_speak = true;

_freq = [];	
_radioCount = {
	if ((_x call TFAR_fnc_getAdditionalSwChannel) == (_x call TFAR_fnc_getSwChannel)) then {
		_freq set[count _freq, format ["%1%2|%3|%4", _x call TFAR_fnc_getSwFrequency, _x call TFAR_fnc_getSwRadioCode, _x call TFAR_fnc_getSwVolume, _x call TFAR_fnc_getAdditionalSwStereo]];
	} else {
		_freq set[count _freq, format ["%1%2|%3|%4", _x call TFAR_fnc_getSwFrequency, _x call TFAR_fnc_getSwRadioCode, _x call TFAR_fnc_getSwVolume, _x call TFAR_fnc_getSwStereo]];
		if ((_x call TFAR_fnc_getAdditionalSwChannel) > -1) then {
			_freq set[count _freq, format ["%1%2|%3|%4", [_x, (_x call TFAR_fnc_getAdditionalSwChannel) + 1] call TFAR_fnc_GetChannelFrequency, _x call TFAR_fnc_getSwRadioCode, _x call TFAR_fnc_getSwVolume, _x call TFAR_fnc_getAdditionalSwStereo]];
		};
	};
	true
} count (call TFAR_fnc_radiosList);

if (_radioCount == 0)then{
	_freq = ["No_SW_Radio"];
};

_freq_lr = [];
_radioCount = {
	if ((_x call TFAR_fnc_getAdditionalLrChannel) == (_x call TFAR_fnc_getLrChannel)) then {
		_freq_lr set[count _freq_lr, format ["%1%2|%3|%4", _x call TFAR_fnc_getLrFrequency, _x call TFAR_fnc_getLrRadioCode, _x call TFAR_fnc_getLrVolume, _x call TFAR_fnc_getAdditionalLrStereo]];
	} else {
		_freq_lr set[count _freq_lr, format ["%1%2|%3|%4", _x call TFAR_fnc_getLrFrequency, _x call TFAR_fnc_getLrRadioCode, _x call TFAR_fnc_getLrVolume, _x call TFAR_fnc_getLrStereo]];
		if ((_x call TFAR_fnc_getAdditionalLrChannel) > -1) then {
			_freq_lr set[count _freq_lr, format ["%1%2|%3|%4", [_x, (_x call TFAR_fnc_getAdditionalLrChannel) + 1] call TFAR_fnc_GetChannelFrequency, _x call TFAR_fnc_getLrRadioCode, _x call TFAR_fnc_getLrVolume, _x call TFAR_fnc_getAdditionalLrStereo]];
		};
	};
	true
} count (call TFAR_fnc_lrRadiosList);

if (_radioCount == 0)then{
	_freq_lr = ["No_LR_Radio"];
};

_freq_dd = "No_DD_Radio";
/*
if ((call TFAR_fnc_haveDDRadio) and {[_depth, _isolated_and_inside] call TFAR_fnc_canUseDDRadio}) then {
	_freq_dd = TF_dd_frequency;
};
*/

//_alive = alive player;
_alive = true;
_nickname = name player;
_globalVolume = player getVariable ["tf_globalVolume",1];
_voiceVolume = player getVariable ["tf_voiceVolume",1];
_receivingDistanceMultiplicator = player getVariable ["tf_receivingDistanceMultiplicator",1];

_request = format["FREQ	%1	%2	%3	%4	%5	%6	%7	%8	%9	%10	%11	%12", str(_freq), str(_freq_lr), _freq_dd, _alive, TF_speak_volume_meters min TF_max_voice_volume, TF_dd_volume_level, _nickname, waves, TF_terrain_interception_coefficient, _globalVolume, _voiceVolume, _receivingDistanceMultiplicator];
_result = "task_force_radio_pipe" callExtension _request;