/*
[] execVM "module_weather\init.sqf";
*/

diag_log format["test0: %1",pvpfw_param_weatherStart];

sleep 0.1;

"pvpfw_weather_sync" addPublicVariableEventhandler{
	if (isNil "pvpfw_weather_noClientForce") then{
		forceWeatherChange;
	};
};

if (!isServer) exitWith{};

_priorityValue1 = param [0,0];
_priorityValue2 = param [1,0];
[_priorityValue1,_priorityValue2] call compile preProcessFileLineNumbers "module_weather\config.sqf";

publicVariable "pvpfw_param_weatherStart";
publicVariable "pvpfw_param_weatherStartArr";

// Initial Conditions

_overcast = [pvpfw_param_weatherStartArr,0,-1] call BIS_fnc_param;
_rain = [pvpfw_param_weatherStartArr,1,-1] call BIS_fnc_param;
_fog = [pvpfw_param_weatherStartArr,2,-1] call BIS_fnc_param;
_waves = [pvpfw_param_weatherStartArr,3,-1] call BIS_fnc_param;
_lightning = [pvpfw_param_weatherStartArr,4,-1] call BIS_fnc_param;

if (_overcast != -1)then{0 setOvercast _overcast;};
if (_rain != -1)then{0 setRain _rain;};
if (_fog != -1)then{0 setFog _fog;};
if (_waves != -1)then{0 setWaves _waves;};
if (_lightning != -1)then{0 setLightnings _lightning;};

sleep 1;

forceWeatherChange;

sleep 1;

_overcast = [pvpfw_param_weatherForecastArr,0,-1] call BIS_fnc_param;
_rain = [pvpfw_param_weatherForecastArr,1,-1] call BIS_fnc_param;
_fog = [pvpfw_param_weatherForecastArr,2,-1] call BIS_fnc_param;
_waves = [pvpfw_param_weatherForecastArr,3,-1] call BIS_fnc_param;
_lightning = [pvpfw_param_weatherForecastArr,4,-1] call BIS_fnc_param;

if (_overcast != -1)then{(pvpfw_param_weatherChangeDuration * 60) setOvercast _overcast;};
if (_rain != -1)then{(pvpfw_param_weatherChangeDuration * 60) setRain _rain;};
if (_fog != -1)then{(pvpfw_param_weatherChangeDuration * 60) setFog _fog;};
if (_waves != -1)then{(pvpfw_param_weatherChangeDuration * 60) setWaves _waves;};
if (_lightning != -1)then{(pvpfw_param_weatherChangeDuration * 60) setLightnings _lightning;};

sleep 0.5;

pvpfw_weather_nextChange = nextWeatherChange;
publicVariable "pvpfw_weather_nextChange";

sleep 0.5;

simulWeatherSync;

sleep 0.5;

pvpfw_weather_sync = true;
publicVariable "pvpfw_weather_sync";