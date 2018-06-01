private["_showIn3D","_marker","_ownMarker","_type","_text","_changedAndExit","_directionalMarker"];

_marker = _this select 0;
_ownMarker = _this select 1; // True if the marker was created on this machine. False if it was created by someone else.

// If this array is not empty at the end of this script, then a 3D marker will be created for it.
// [marker_name,3D_icon,duration,only_show_for_certain_players ("" for all, "pilots" for pilot classes as defined in the config.sqf, etc.)]
_showIn3D = [];

_type = markerType _marker;
_text = markerText _marker;

// Generally change the size and alpha for all default markers, which makes them a bit nicer to look at and shows, that they were intercepted by the script.
_marker setMarkerAlphaLocal 0.8;
_marker setMarkerSizeLocal [0.67,0.67];

// Timestamp begin (will get the current inGame minute, so we can add it to the end of certain markers)
private["_hour","_minute","_second","_timeStamp"];
_hour = floor daytime;
_minute = floor ((daytime - _hour) * 60);
_second = floor (((((daytime) - (_hour))*60) - _minute)*60);

if (_second > 45)then{
	_minute = _minute + 1;
	if (_minute == 60)then{
		_minute = 0;
	};
};

_timeStamp = str _minute;
if ((count (toArray _timeStamp)) == 1)then{
	_timeStamp = "0" + _timeStamp;
};
// Timestamp end

_changedAndExit = true; // if this var remains true after this first switch, then the script wont bother with the second switch to check for a 3 character prefix

// 2 character prefix check
switch(tolower([_text,0,1] call BIS_fnc_trimString))do{
	case("xx"):{ //use this prefix if your actual markertext starts with another prefix, but you dont want it to be matched against anything in this list
		_marker setmarkerTextLocal ([_text,2] call BIS_fnc_trimString);
	};
	case("ei"):{ // Enemy infantry
		_marker setMarkerColorLocal "ColorRed";
		_marker setMarkerTypeLocal "hd_dot";
		_marker setMarkerTextLocal format["%1:%2",_text,_timeStamp];
		_showIn3D = [_marker,"a3\ui_f\data\map\Markers\Military\dot_ca.paa",6,""]; //show to all players in the same channel for 6 seconds
	};
	case("e "):{ // Enemy X
		_marker setMarkerColorLocal "ColorRed";
		_marker setMarkerTypeLocal "hd_dot";
		_marker setMarkerTextLocal format["%1:%2",_text,_timeStamp];
		_showIn3D = [_marker,"a3\ui_f\data\map\Markers\Military\dot_ca.paa",15,""]; //show to all players in the same channel for 15 seconds
	};
	case("lz"):{ // Landing zone
		_marker setMarkerTypeLocal "hd_pickup";
		_marker setmarkerTextLocal ([_text,2] call BIS_fnc_trimString);
		_showIn3D = [_marker,"a3\ui_f\data\map\Markers\Military\pickup_ca.paa",99999,"pilots"]; //show to all pilots in the same channel until the marker is deleted
	};
	case("dz"):{ // Drop zone
		_marker setMarkerTypeLocal "hd_end";
		_marker setmarkerTextLocal ([_text,2] call BIS_fnc_trimString);
	};
	case("??"):{ // Creates question mark
		_marker setMarkerTypeLocal "hd_unknown";
		_marker setmarkerTextLocal ([_text,2] call BIS_fnc_trimString);
	};
	case("!!"):{ // creates exclamation mark
		_marker setMarkerTypeLocal "hd_warning";
		_marker setmarkerTextLocal ([_text,2] call BIS_fnc_trimString);
	};
	case("::"):{ // Creates admin marker (does nothing if placed by non-admins)
		if (_ownMarker && (serverCommandAvailable "#kick" || !isMultiplayer))then{
			_persMarker = createMarkerLocal["pvpfw_mi_persistent_" + str(random 1000000),markerPos _marker];
			_persMarker setMarkerSizeLocal [0.67,0.67];
			_persMarker setMarkerTypeLocal "mil_box_noshadow";
			_persMarker setMarkerDirLocal 45;
			_persMarker setMarkerText ([_text,2] call BIS_fnc_trimString);

			deleteMarker _marker;
		};
	};
	default{_changedAndExit = false;};
};

// if no match was found for the first 2 characters go ahead and check for a 3 character prefix
if (!_changedAndExit) then{
	switch(tolower([_text,0,2] call BIS_fnc_trimString))do{
		case("dir"):{ // Creates an arrow with the specified direction (dir220ei moving, dir45Tank, etc.)
			private["_dir","_fullArray","_endArray","_offSet"];
			if (markerColor _marker == "Default") then{_marker setMarkerColorLocal "ColorRed";};

			_dir = (parseNumber ([_text,3,5] call BIS_fnc_trimString));
			_marker setMarkerDirLocal (_dir + 6);
			_marker setMarkerTypeLocal "hd_arrow";

			_fullArray = toArray _text;
			_endArray = [];

			_offSet = 0;
			if (_dir < 100) then{_offSet = _offSet - 1};
			if (_dir < 10) then{_offSet = _offSet - 1};

			if (count _fullArray >= 5 + _offSet) then{
				for "_i" from 6 + _offSet to ((count _fullArray) -1) do{
					_endArray pushback (_fullArray select _i);
				};
			};

			_marker setMarkerTextLocal (toString _endArray);
		};
		case("elz"):{ // enemy LZ
			_marker setMarkerColorLocal "ColorRed";
			_marker setMarkerTypeLocal "hd_pickup";
			_marker setMarkerTextLocal format["%1:%2",_text,_timeStamp];
		};
		case("obj"):{ // objective
			_marker setMarkerTypeLocal "hd_flag";
			_marker setmarkerTextLocal ([_text,3] call BIS_fnc_trimString);
		};
		case("med"):{ // info marker for medics (for testing the 3d class)
			_marker setMarkerSizeLocal [0.5,0.5];
			_marker setMarkerColorLocal "ColorRed";
			_marker setMarkerTypeLocal "mil_warning";
			_marker setmarkerTextLocal "Medic!";
			_showIn3D = [_marker,"a3\ui_f\data\map\Markers\Military\warning_ca.paa",9999,"medics"]; //test marker for medic classes
		};
		default{};
	};
};

if (count _showIn3D != 0) then{
	_showIn3D call pvpfw_fnc_mi_showIn3D;
};
