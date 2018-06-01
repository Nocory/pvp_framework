//////////////////////
// Base Safe Zones
//////////////////////

_safeZoneSize = 800;

{
	if (markerColor _x != "") then{
		_x setMarkerShapeLocal "ELLIPSE";
		_x setMarkerBrushLocal "Border";
		_x setMarkerAlphaLocal 1;
		_x setMarkerSizeLocal [_safeZoneSize,_safeZoneSize];
		_x setMarkerColorLocal "ColorBlack";

		_marker = createMarkerLocal [_x + "_color", markerPos _x];
		_marker setMarkerShapeLocal "ELLIPSE";
		_marker setMarkerBrushLocal "Border";
		_marker setMarkerAlphaLocal 0.5;
		_marker setMarkerSizeLocal [_safeZoneSize - 2,_safeZoneSize - 2];
		_marker setMarkerColorLocal (["ColorBlufor","ColorOpfor"] select _forEachIndex);
	};
}forEach ["pvpfw_respawn_west","pvpfw_respawn_east"];

[[],{
	scriptName "pvpfw_sec_preventBaseFiring";

	private["_actionID"];

	while{true}do{
		waitUntil{sleep 1.2;((getPosATL player) distance (markerPos format["pvpfw_respawn_%1",player getVariable["pvpfw_customSide",civilian]])) < 200};
		_actionID = player addAction ["",{
			["<t size='0.8' shadow='2' color='#ffffffff' font='PuristaBold'>" + "Weapon safety engaged inside the base" + "</t>",0,0.25,0.25,0,0,"pvpfw_sec_layer"] spawn BIS_fnc_dynamicText;
			if (player == vehicle player)then{
				playSound3D ["a3\sounds_f\weapons\Other\dry9.wss", _this select 0];
			};
		}, "", 0, false, true, "DefaultAction","true"];
		waitUntil{sleep 1.2;((getPosATL player) distance (markerPos format["pvpfw_respawn_%1",player getVariable["pvpfw_customSide",civilian]])) > 200};
		player removeAction _actionID;
	};
},"pvpfw_sec_preventBaseFiring"] call pvpfw_fnc_spawnOnce;



/*
//exit if training mode or not a fighting side
if (pvpfw_enemySafeZoneMarker == "" || pvpfw_param_trainingEnabled == 1 || pvpfw_playerIsAdmin || playerSide in [civilian,independent]) exitWith{};

//kill the player when entering the enemies safezone
pvpfw_baseprotection = [] spawn{true};
[[],{
	if ((player distance (markerPos pvpfw_enemySafeZoneMarker)) < pvpfw_sec_safeZoneSize) then{
		if (scriptDone pvpfw_baseprotection)then{
			pvpfw_baseprotection = [] spawn{
				private["_timeInSafeZone"];
				_timeInSafeZone = 10;
				while{(player distance (markerPos pvpfw_enemySafeZoneMarker)) < pvpfw_sec_safeZoneSize && alive player}do{
					_timeInSafeZone = _timeInSafeZone - 1;
					if (_timeInSafeZone == 0) exitWith{player setdamage 1;};
					hintSilent format["You have %1 seconds to leave the enemies safezone",_timeInSafeZone];
					sleep 1;
				};
			};
		};
	};
},"pvpfw_baseprotection"] call pvpfw_cse_lowPrioAdd;
