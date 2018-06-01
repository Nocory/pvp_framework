private ["_request","_result", "_unit", "_isNearPlayer"];
_unit = _this select 0;

if (!alive _unit && _unit != player) exitWith{};

_request = _this call TFAR_fnc_preparePositionCoordinates;
_result = "task_force_radio_pipe" callExtension _request;

if !(_result in ["OK","SPEAKING","NOT_SPEAKING"]) then{
	[parseText (_result), 10] call TFAR_fnc_showHint;
	tf_lastError = true;
}else{
	if (tf_lastError) then {
		call TFAR_fnc_hideHint;
		tf_lastError = false;
	};
};

if (_result == "SPEAKING") then {
	_unit setRandomLip true;
} else {
	_unit setRandomLip false;
};