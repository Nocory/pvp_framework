{
	_marker = (_x select 0);
	_markerPos = markerPos _marker;
	_markerDir = markerDir _marker;
	_markerPos set[2,0];
	createVehicle ["Land_ClutterCutter_large_F", _markerPos, [], 0, "CAN_COLLIDE"];
	
	_wepCrate = createVehicle ["I_supplyCrate_F", [_markerPos,2,_markerDir + 90] call BIS_fnc_relPos, [], 0, "CAN_COLLIDE"];
	_wepCrate setDir (_markerDir - 45);
	missionNamespace setVariable[format["%1_wep",_marker],_wepCrate];
	_bagCrate = createVehicle ["I_supplyCrate_F", [_markerPos,2,_markerDir - 90] call BIS_fnc_relPos, [], 0, "CAN_COLLIDE"];
	_bagCrate setDir (_markerDir + 45);
	missionNamespace setVariable[format["%1_bag",_marker],_bagCrate];
	
	_markerPos = [_markerPos,2,_markerDir] call BIS_fnc_relPos;
	_step = 30;
	_dir = _markerDir + 180 - (_step * 2);
	
	for "_i" from 0 to 4 do{
		_sandBagDir = _dir + (_step * _i);
		_sandbagPos = [_markerPos,5.5,_sandBagDir] call BIS_fnc_relPos;
		_object = createVehicle ["Land_BagFence_Long_F", [random 1000, random 1000, 500 + random(500)], [], 0, "CAN_COLLIDE"];
		_object setDir _sandBagDir;
		_object setPosATL _sandBagpos;
		_object setVectorUp (surfaceNormal _sandBagpos);
		pvpfw_template_spawnedObjects pushBack _object;
	};
	
	_step = 50;
	_dir = _markerDir + 180 - _step;
	for "_i" from 0 to 2 do{
		_flagDir = _dir + (_step * _i);
		_flagPos = [_markerPos,7,_flagDir] call BIS_fnc_relPos;
		_object = createVehicle [_x select 1, [random 1000, random 1000, 500 + random(500)], [], 0, "CAN_COLLIDE"];
		_object setDir _flagDir;
		_object setPosATL _flagPos;
		pvpfw_template_spawnedObjects pushBack _object;
	};
}forEach [
	["pvpfw_baseCrate_blu","Flag_Blue_F"],
	["pvpfw_baseCrate_opf","Flag_Red_F"],
	["pvpfw_baseCrate_ind","Flag_Green_F"]
];