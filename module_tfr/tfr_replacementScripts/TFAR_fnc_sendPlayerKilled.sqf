private ["_request", "_result"];
_this setRandomLip false;

if (pvpfw_tfr_enabled) then{
	_request = format["KILLED	%1", name _this];
	_result = "task_force_radio_pipe" callExtension _request;
};