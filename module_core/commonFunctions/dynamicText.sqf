
pvpfw_common_layer = "pvpfw_common_layer" call bis_fnc_rscLayer;
pvpfw_fnc_core_dynamicTextWorkArray = [];

pvpfw_fnc_core_dynamicTextWorkThread = {
	private["_text","_duration","_yCoord","_handle"];
	
	while{count pvpfw_fnc_core_dynamicTextWorkArray != 0}do{
		
		_text = (pvpfw_fnc_core_dynamicTextWorkArray select 0) select 0;
		_duration = (pvpfw_fnc_core_dynamicTextWorkArray select 0) select 1;
		_yCoord = (pvpfw_fnc_core_dynamicTextWorkArray select 0) select 2;
		_yCoord = (safeZoneH * _yCoord) + safeZoneY;
		_fadeIn = (pvpfw_fnc_core_dynamicTextWorkArray select 0) select 3;
		_layer = (pvpfw_fnc_core_dynamicTextWorkArray select 0) select 4;
		
		pvpfw_fnc_core_dynamicTextWorkArray set[0,objNull];
		pvpfw_fnc_core_dynamicTextWorkArray = pvpfw_fnc_core_dynamicTextWorkArray - [objNull];
		
		_handle = ["<t size='0.67' shadow='2' color='#ffffffff' font='PuristaBold'>" + _text + "</t>",0,_yCoord,_duration,_fadeIn,0,_layer] spawn BIS_fnc_dynamicText;
		waitUntil{sleep 0.04;scriptDone _handle};
	};
};

//pvpfw_handle_core_dynamicText = [] spawn{true};

pvpfw_fnc_core_queuedDynamicText = {
	private["_text","_duration","_yCoord"];
	_text 		= param [0,"NO TEXT???"];
	_duration 	= param [1,4];
	_yCoord 	= param [2,0.6];
	_fadeIn 	= param [3,1];
	_layer 		= param [4,pvpfw_common_layer];
	
	pvpfw_fnc_core_dynamicTextWorkArray pushback [_text,_duration,_yCoord,_fadeIn,_layer];
	
	_handle = missionNamespace getVariable[format["pvpfw_handle_core_dynamicText%1",_layer],scriptNull];
	
	if (scriptDone _handle)then{
		_handle = [[],pvpfw_fnc_core_dynamicTextWorkThread,"pvpfw_fnc_core_dynamicTextWorkThread"] call pvpfw_fnc_spawn;
		missionNamespace setVariable[format["pvpfw_handle_core_dynamicText%1",_layer],_handle];
	};
	
	[format["dyntext: %1",[_text,_duration,_yCoord,_fadeIn,_layer]],2] call pvpfw_fnc_log_show;
};
