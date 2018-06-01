pvpfw_fnc_perf_monitorClient = {
	private["_layer","_text"];
	scriptName "pvpfw_perf_monitorClient";
	
	_layer = "pvpfw_perf_monitorClient" call bis_fnc_rscLayer;
	
	waitUntil{sleep 0.53;!isNil "pvpfw_cse_msPerFrame" && !isNil "pvpfw_ii_drawTimePerFrame"};
	
	while{true}do{
		_text = "<t size='0.45' shadow='2' color='#ffffff'>" +
		"FPS: " + str(round diag_fps) + "<br/>" +
		"ST+DT = " + str([pvpfw_cse_msPerFrame,2] call BIS_fnc_cutDecimals) + " + " + str([pvpfw_ii_drawTimePerFrame,2] call BIS_fnc_cutDecimals) + "</t>";
		
		[_text,0,safeZoneY + (SafeZoneH * 0.80),2,0,0,_layer] spawn BIS_fnc_dynamicText;
		sleep 1;
	};	
};