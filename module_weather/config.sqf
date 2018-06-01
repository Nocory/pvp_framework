/*
"Default","Clear","Some Clouds","Overcast","Light Rain","Moderate Rain","Heavy Rain","Storm","Slight Fog","Medium Fog"
*/

diag_log format["test1: %1",pvpfw_param_weatherStart];

_priorityValue1 = param [0,0];
if (_priorityValue1 != 0)then{pvpfw_param_weatherStart = _priorityValue1};
_priorityValue2 = param [1,0];
if (_priorityValue2 != 0)then{pvpfw_param_weatherForecast = _priorityValue2};

diag_log format["test2: %1",pvpfw_param_weatherStart];

{
	//_weatherSettings = [overcast, rain, fog, waves, lightning]
	
	_weatherStartVar = missionNamespace getVariable[_x,-1];
	diag_log format["### Weather Start-Var: %1 - %2",_weatherStartVar,_x];
	_weatherSettings = switch(_weatherStartVar)do{
		case(0):{[-1,-1,-1,-1,-1]};
		case(1):{[0,0,0,0,0]}; //Clear
		case(2):{[0.5,0,0,0.1,0]}; //Cloudy
		case(3):{[0.8,0.01,0.05,0.4,0]}; //Overcast
		case(4):{[0.75,0.1,0.05,0.1,0]}; //Light Rain
		case(5):{[0.85,0.375,0.1,0.2,0]}; //Moderate Rain
		case(6):{[1,0.75,0.25,0.4,0.2]}; //Heavy Rain
		case(7):{[1,1,0.4,0.8,0.6]}; //Storm
		case(8):{[0.3,0,0.15,0,0]}; //Light Fog
		case(9):{[0.3,0,0.25,0,0]}; //Moderate Fog
		case(10):{[0.3,0,0.4,0,0]}; //Thick Fog
		default{[-1,-1,-1,-1,-1]};
	};
	
	missionNamespace setVariable[_x + "Arr",_weatherSettings];
}forEach ["pvpfw_param_weatherStart","pvpfw_param_weatherForecast"];