
pvpfw_uav_center = _this param [0,player];
pvpfw_uav_target = getPosATL pvpfw_uav_center;
pvpfw_uav_viewMode = 2;

disableSerialization;

if (!isNull (findDisplay 19506)) exitWith{};

_helperCtrl = (findDisplay 19506) ctrlCreate ["RscButton", 21];
_helperCtrl ctrlSetPosition [-2,-2,0,0];
_helperCtrl ctrlSetFade 1;
_helperCtrl ctrlCommit 0;

_textCtrl = (findDisplay 19506) ctrlCreate ["RscStructuredText", 22];
_textCtrl ctrlSetPosition [0.5,0.5,safezoneW * 0.1,safezoneH * 0.05];
_textCtrl ctrlSetText "test";
_textCtrl ctrlCommit 0;

_headingControls = [];
for "_i" from 30 to 33 do{
	_control = (findDisplay 19506) ctrlCreate ["RscStructuredText",_i];
	_control ctrlSetFade 0.34;
	_control ctrlCommit 0;
	_headingControls pushback _control;
};

_fullScreenCtrl = (findDisplay 19506) ctrlCreate ["RscShortcutButton",3334];
_fullScreenCtrl ctrlSetPosition [safeZoneX,safeZoneY,safeZoneW,safezoneH];
_fullScreenCtrl ctrlSetFade 1;
//_fullScreenCtrl ctrlSetBackgroundColor [0, 0, 0, 0.2];
//_fullScreenCtrl ctrlSetFade 0.5;
_fullScreenCtrl ctrlCommit 0;


myDebugID = _fullScreenCtrl ctrlAddEventHandler ["MouseMoving",{
	pvpfw_uav_debugVar = _this;
}];

myDebugID3 = _fullScreenCtrl ctrlAddEventHandler ["MouseZChanged",{
	systemChat str(_this);
	
	if ((_this select 1) > 0)then{
		[]spawn{sleep 0.2;pvpfw_uav_cam camPrepareFov 0.2;pvpfw_uav_cam camCommitPrepared 1;[] call pvpfw_uav_fnc_zoomBlur;};
	};
	
	if ((_this select 1) < 0)then{
		[]spawn{sleep 0.2;pvpfw_uav_cam camPrepareFov 0.5;pvpfw_uav_cam camCommitPrepared 1;[] call pvpfw_uav_fnc_zoomBlur;};
	};
}];

myDebugID3 = _fullScreenCtrl ctrlAddEventHandler ["MouseButtonDown",{
	if (diag_tickTime < pvpfw_uav_nexttargetChange) exitWith{};
	
	if (_this select 1 == 0)then{
		pvpfw_uav_nexttargetChange = diag_tickTime + 1.2;
		
		_this spawn{
			sleep 0.2;
			_clickX = _this select 2;
			_clickY = _this select 3;
			
			_worldPos = screenToWorld [_clickX,_clickY];
			
			pvpfw_uav_cam camSetTarget _worldPos;
		};
	};
	if (_this select 1 == 1)then{
		pvpfw_uav_viewMode = (pvpfw_uav_viewMode + 1) % 3;
		
		if (pvpfw_uav_viewMode < 2)then{
			true setCamUseTi pvpfw_uav_viewMode;
		}else{
			false setCamUseTi pvpfw_uav_viewMode;
		};
	};
}];

pvpfw_uav_ppEffectChrom = ppEffectCreate ["ChromAberration", 700];
pvpfw_uav_ppEffectBlur = ppEffectCreate ["dynamicBlur", 701];
pvpfw_uav_ppEffectGrain = ppEffectCreate ["FilmGrain", 702];

pvpfw_uav_ppEffectChrom ppEffectAdjust [0.005, 0.005, false];
pvpfw_uav_ppEffectChrom ppEffectEnable true;
pvpfw_uav_ppEffectChrom ppEffectCommit 0;

pvpfw_uav_ppEffectGrain ppEffectAdjust [
	0.5, //intensity
	2.5, //sharpness
	1.7, //grainSize
	0.2, //intensityX0
	1.0, //intensityX1
	true //monochromatic
];

pvpfw_uav_fnc_zoomBlur = {
	pvpfw_uav_ppEffectBlur ppEffectEnable true;
	pvpfw_uav_ppEffectBlur ppEffectAdjust [5];
	pvpfw_uav_ppEffectBlur ppEffectCommit 0.4;
	sleep 0.4;
	pvpfw_uav_ppEffectBlur ppEffectAdjust [0];
	pvpfw_uav_ppEffectBlur ppEffectCommit 0.6;
	sleep 0.7;
	pvpfw_uav_ppEffectBlur ppEffectEnable false;
};

pvpfw_uav_active = true;

_camPos = getPosATL pvpfw_uav_center;
_dir = (diag_tickTime % 120) * 3;
_camPos = [_camPos,50,_dir] call BIS_fnc_relPos;
_camPos set [2,300];

if (!isNil "pvpfw_uav_cam")then{camdestroy pvpfw_uav_cam;};

pvpfw_uav_cam = "camera" CamCreate _camPos;
showCinemaborder false;
pvpfw_uav_cam camSetTarget pvpfw_uav_center;
pvpfw_uav_cam camSetFov 0.35;
pvpfw_uav_cam camCommit 0;

//pvpfw_uav_cam switchCamera "Internal";
4 cutText ["","BLACK FADED",0];
pvpfw_uav_cam CameraEffect ["internal","back"];
sleep 1;
4 cutText ["","BLACK IN",1];

["pvpfw_fnc_uav_circleObserver","onEachFrame",{	
	_dir = (diag_tickTime % 120) * 3;
	_camPos = [pvpfw_uav_center,300,_dir] call BIS_fnc_relPos;
	_camPos set [2,300];
	
	pvpfw_uav_cam camSetPos _camPos;
	pvpfw_uav_cam camCommit 1;
	
	// draw line north
	/*
	_cvPos = getPosATL _CV;
	_cvPos = camTarget pvpfw_uav_cam;
	systemChat str(_cvPos);
	_cvPos set[2,0];
	
	_headingControls = _this select 3;
	
	_relCoord = screenToWorld [0.5 + (safezoneW * 0.2),0.5];
	//_relCoord = screenToWorld [0.5,0.5];
	_relCoord set[2,_cvPos select 2];
	_relDist = _cvPos distance _relCoord;
	//_relPos = [_relCoord,] call BIS_fnc_relPos;
	
	{
		_nPos = [_cvPos,_relDist,(_x select 0)] call BIS_fnc_relPos;
		
		_screenPos = worldToScreen _nPos;
		
		_control = _x select 2;
		
		_text = format["<t align='center' font='PuristaBold' shadow='2' size='0.85' color='#ffffff'>%1</t>",_x select 1];
		_control ctrlSetStructuredText parseText _text;
		//_control ctrlSetBackgroundColor [0, 0, 0, 0.2];
		//_control ctrlSetFade 0;
		
		//_control ctrlSetText (_x select 1);
		_width = safezoneW * 0.02;
		_height = safezoneH * 0.02;
		_control ctrlSetPosition [(_screenPos select 0) - _width / 2,(_screenPos select 1) - _height / 2,_width,_height];
		_control ctrlCommit 0;
		
		//drawIcon3D ["a3\ui_f\data\map\Markers\Military\pickup_ca.paa", [1,1,1,1], _nPos, 0, 0, 0, (_x select 1), 2, 0.04,"PuristaMedium"];
	}forEach [
		[0,"N",_headingControls select 0],
		[90,"E",_headingControls select 1],
		[180,"S",_headingControls select 2],
		[270,"W",_headingControls select 3]
	];
	*/
	_xCoord = pvpfw_uav_debugVar select 1;
	_yCoord = pvpfw_uav_debugVar select 2;
	
	_wPos = screenToWorld [_xCoord,_yCoord];
	
	_textCtrl = _this select 2;
	
	_text = format["<t align='left' font='PuristaBold' shadow='2' size='0.85' color='#ffffff'>%1m - %2*</t>",round(pvpfw_uav_center distance _wPos),round([pvpfw_uav_center,_wPos] call BIS_fnc_dirTo)];
	
	_textCtrl ctrlSetStructuredText parseText _text;
	_textCtrl ctrlSetPosition [_xCoord + safeZoneW * 0.01,_yCoord,safezoneW * 0.2,safezoneH * 0.05];
	_textCtrl ctrlCommit 0;
	
	if !(alive pvpfw_uav_center && alive player && player == commander pvpfw_uav_center && pvpfw_uav_active && !isNull (findDisplay 19506)) then{
		ppEffectDestroy [pvpfw_uav_ppEffectChrom,pvpfw_uav_ppEffectBlur,pvpfw_uav_ppEffectGrain];
		["pvpfw_fnc_uav_circleObserver","onEachFrame"] call BIS_fnc_removeStackedEventHandler;
		false setCamUseTi 0;
		pvpfw_uav_active = false;
		
		closedialog 0;
		
		[] spawn{
			4 cutText ["","BLACK FADED",0];
			pvpfw_uav_cam cameraeffect ["terminate","back"];
			camdestroy pvpfw_uav_cam;
			sleep 1;
			4 cutText ["","BLACK IN",1];
		};
	};
},[_textCtrl,_headingControls]] call BIS_fnc_addStackedEventHandler;

