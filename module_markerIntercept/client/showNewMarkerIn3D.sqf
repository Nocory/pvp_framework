
// Still a very new feature

// Certain markers will be displayed in the normal 3D view.
// Currently by default these are only "ei", "e " (e + space) and "LZ" markers.
// Marked enemies will only be displayed temporarily (basically just a quick hint, for the case, that someone marked some enemy infantry 200m to your front)
// Marked LZs are displayed permanently for the defined pilot slots (see config.sqf), until they are deleted.

pvpfw_mi_3DMarker = missionNamespace getVariable["pvpfw_mi_3DMarker",[]];
pvpfw_mi_3DMarkerFinal = [];

pvpfw_mi_players3DClasses = [];
{
	if ((typeOf player) in (_x select 1))then{
		pvpfw_mi_players3DClasses pushback (_x select 0);
	};
}forEach pvpfw_mi_3DClasses;

pvpfw_fnc_mi_showIn3D = {
	private["_marker","_icon","_duration","_showFor","_pos","_text"];
	_marker = _this select 0;
	_icon = _this select 1;
	_duration = _this select 2;
	_showFor = _this select 3;

	if (_showFor != "" && {!(_showFor in pvpfw_mi_players3DClasses)}) exitWith{};

	_pos = (markerPos _marker);
	_pos set[2,2];
	_text = markerText _marker;

	pvpfw_mi_3DMarker pushBack [_marker,_pos,_icon,_text,diag_tickTime + _duration];
};

[[],{
	scriptName "pvpfw_fnc_mi_showIn3D";
	/*
	pvpfw_mi_next3DReport = diag_tickTime + 5;
	pvpfw_mi_frameTime = 0;
	pvpfw_mi_frameCounter = 0;
	*/
	pvpfw_mi_missionEH = addMissionEventHandler ["Draw3D",{
		//_initTime = diag_tickTime;
		{
			_pos = _x select 1;
			_text = format["%1 %2m",_x select 3,round(getPosATL player distance _pos)];
			_screenPos = worldToScreen _pos;
			if (count _screenPos != 0) then{
				_alphaToSubstract = (0.5 - (_screenPos distance [0.5,0.5])) max 0;
				drawIcon3D [(_x select 2), [1,1,1,((((_x select 4) - diag_tickTime) / 4) min 1) - _alphaToSubstract], _pos, 0.5, 0.5, 0, _text, 2, 0.03,"PuristaMedium"];
			};
		}forEach pvpfw_mi_3DMarkerFinal;
		/*
		pvpfw_mi_frameTime = pvpfw_mi_frameTime + (diag_tickTime - _initTime);
		pvpfw_mi_frameCounter = pvpfw_mi_frameCounter + 1;
		if (diag_tickTime >= pvpfw_mi_next3DReport) then{
			systemChat format["average lacm 3d time: %1ms",(pvpfw_mi_frameTime / pvpfw_mi_frameCounter) * 1000];

			pvpfw_mi_next3DReport = diag_tickTime + 5;
			pvpfw_mi_frameTime = 0;
			pvpfw_mi_frameCounter = 0;
		};
		*/
	}];
	
	while{true}do{
		{
			if (diag_tickTime > (_x select 4) || markerColor (_x select 0) == "") then{
				pvpfw_mi_3DMarker set[_forEachIndex,objNull];
			};
			uisleep 0.05;
		}forEach pvpfw_mi_3DMarker;
		uisleep 0.11;
		pvpfw_mi_3DMarker = pvpfw_mi_3DMarker - [objNull];
		uisleep 0.12;
		pvpfw_mi_3DMarkerFinal =  + pvpfw_mi_3DMarker;
		uisleep 0.13;
	};
},"pvpfw_mi_showIn3D"] call pvpfw_fnc_spawnOnce;
