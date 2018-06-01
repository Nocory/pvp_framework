

[[],{
	scriptName "pvpfw_fortificationMarker";
	private["_checkArray","_boundingMarkerCounter","_createmarker"];
	_checkArray = [];

	_boundingMarkerCounter = 0;

	_createmarker = {
		private["_object","_markerName"];
		
		_object = _this;
		_object setVariable ["pvpfw_markers_boundingMarkerSet",true,false];
		_builtBy = _this getVariable["pvpfw_ci_builtBy",independent];
		
		if (playerSide != _builtBy) exitWith{};
		
		_markerName = createMarkerLocal [format["pvpfw_marker_boundingMarker_%1",_boundingMarkerCounter], getPosATL _object];
		_markername setMarkerDirLocal (direction _object);
		_size = (boundingBoxReal _object) select 1;
		_size resize 2;
		_markername setMarkerSizeLocal _size;
		_markername setMarkerShapeLocal "RECTANGLE";
		
		switch(_builtBy)do{
			case(blufor):{
				_markername setMarkerColorLocal "ColorBlufor";
			};
			case(opfor):{
				_markername setMarkerColorLocal "ColorOpfor";
			};
		};
		
		_checkArray pushBack [_object,_markername];
		_boundingMarkerCounter = _boundingMarkerCounter + 1;
	};

	while{true}do{
		{
			if (!(_x getVariable ["pvpfw_markers_boundingMarkerSet",false])) then{
				_x call _createmarker;
			};
			sleep 0.1;
		}forEach allMissionObjects "Strategic";
		
		sleep 0.1;
		
		{
			if (isNull (_x select 0)) then{
				deleteMarkerLocal (_x select 1);
				_checkArray set[_forEachIndex,objNull];
			};
			sleep 0.1;
		}forEach _checkArray;
		
		sleep 0.1;
		_checkArray = _checkArray - [objNull];
		sleep 1;
	};
},"pvpfw_fortificationMarker"] call pvpfw_fnc_spawn;

