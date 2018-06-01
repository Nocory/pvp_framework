
scriptname "pvpfw_ambientVehicles";

_createVehicle = {
	_pos = _this select 0;
	_dir = _this select 1;
	_type = _this select 2;

	_vehicle = createVehicle [_type, [random 1000,random 1000, 1000 + (random 1000)], [], 0, "NONE"];
	_vehicle setDir _dir;

	//check if the area is free of obstacles
	_bbox = boundingBoxReal _vehicle;
	_bcenter = boundingcenter _vehicle;

	_front = [_pos,0 + ((_bbox select 1) select 1),_dir] call BIS_fnc_relPos;
	_front set[2,0.5];
	_rear = [_pos,0 + ((_bbox select 0) select 1),_dir] call BIS_fnc_relPos;
	_rear set[2,0.5];

	_fl = ATLtoASL ([_front,((_bbox select 0) select 0),_dir + 90] call BIS_fnc_relPos);
	_fr = ATLtoASL ([_front,((_bbox select 1) select 0),_dir + 90] call BIS_fnc_relPos);
	_rl = ATLtoASL ([_rear,((_bbox select 0) select 0),_dir + 90] call BIS_fnc_relPos);
	_rr = ATLtoASL ([_rear,((_bbox select 1) select 0),_dir + 90] call BIS_fnc_relPos);

	{
		//_orb = createVehicle [_x select 1, ASLtoATL (_x select 0), [], 0, "CAN_COLLIDE"];
		//pvpfw_ambient_allHelperArrows pushBack _orb;
	}forEach [[_fl,"Sign_Pointer_Green_F"],[_fr,"Sign_Pointer_Blue_F"],[_rl,"Sign_Pointer_Pink_F"],[_rr,"Sign_Pointer_Yellow_F"]];

	_lineIntersectsWith = (lineIntersectsWith [_fl, _rr]) + (lineIntersectsWith [_fr, _rl]) + (lineIntersectsWith [_fl, _rl]) + (lineIntersectsWith [_fr, _rr]);

	if ((count _lineIntersectsWith) > 0) then{
		if (_type isKindOf "Car")then{
			_pos = [_pos,2,_dir - 90] call BIS_fnc_relPos;
		}else{
			deleteVehicle _x; //i dont know
		};
	};

	_pos set[2,0.5];
	_vehicle setPosATL _pos;

	switch(true)do{
		case(_type isKindOf "Car"):{
			pvpfw_ambient_allVehicles pushBack _vehicle;
			[getPosATL _vehicle,"hd_dot","ColorRed",[0.5,0.5]] call _createMarker;
		};
		case(_type isKindOf "Air"):{
			pvpfw_ambient_allChoppers pushback _vehicle;
			[getPosATL _vehicle,"hd_dot","ColorBlue",[0.5,0.5]] call _createMarker;
		};
	};

	clearWeaponCargoGlobal _vehicle;
  clearMagazineCargoGlobal _vehicle;
  clearItemCargoGlobal _vehicle;
  clearBackpackCargoGlobal _vehicle;
};

_createMarker = {
	if !(isNil "pvpfw_ambient_noDebugMarkers") exitWith{};
	private["_pos","_type","_size"];
	_pos = _this select 0;
	_type = _this select 1;
	_color = _this select 2;
	_size = _this select 3;

	_marker = createMarker [format["testMarker%1%2%3",random 100,random 100,random 100], _pos];
	_marker setMarkerType _type;
	_marker setMarkerColor _color;
	_marker setMarkerSize _size;
	pvpfw_ambient_helperMarkers set [count pvpfw_ambient_helperMarkers,_marker];
};

// Reset and remove all previous objects
pvpfw_ambient_allVehicles = missionNamespace getVariable["pvpfw_ambient_allVehicles",[]];
pvpfw_ambient_allChoppers = missionNamespace getVariable["pvpfw_ambient_allChoppers",[]];
pvpfw_ambient_allHelperArrows = missionNamespace getVariable["pvpfw_ambient_allHelperArrows",[]];

pvpfw_ambient_helperMarkers = missionNamespace getVariable["pvpfw_ambient_helperMarkers",[]];

{
	{deleteVehicle _x}forEach _x;
	_x resize 0;
}forEach[pvpfw_ambient_allVehicles,pvpfw_ambient_allChoppers,pvpfw_ambient_allHelperArrows];

{
	deleteMarker _x;
}forEach pvpfw_ambient_helperMarkers;
pvpfw_ambient_helperMarkers resize 0;

// Start the creating of vehicles

_spawnPos = [_this,0,[15000,15000]] call BIS_fnc_param;
_maxRoadDist = [_this,1,20000] call BIS_fnc_param;
_step = [_this,2,1] call BIS_fnc_param;
_minCarDist = [_this,3,100] call BIS_fnc_param;
_extraChance = [_this,4,0.01] call BIS_fnc_param;
_chanceToSkip = [_this,5,0.0] call BIS_fnc_param;

_allRoads = [];
_suitableRoads = [];
_finalRoads = [];

_allRoads = ([0,0,0] nearRoads _maxRoadDist) call BIS_fnc_arrayShuffle;
_allRoadsCount = count _allRoads;
{
	if ((count (roadsConnectedTo _x)) > 0)then{
		_houses = (getPosATL _x) nearObjects ["House",35];
		{
			if (typeOf _x in pvpfw_ambient_buildingsToIgnore)then{
				_houses set[_forEachIndex,objNull];
			};
		}forEach _houses;
		_houses = _houses - [objNull];
		_houseCount = (count _houses) min 5;
		_ruinCount = (count ((getPosATL _x) nearObjects ["Ruins_F",35])) min 2;

		_combined = _houseCount + _ruinCount;

		if (_combined > 0)then{
			_suitableRoads pushBack [_x,_combined];
		};
	};
	if(pvpfw_ambient_debugMode)then{systemChat format["all road: %1 / %2",_forEachIndex,_allRoadsCount];};
}forEach _allRoads;

{
	if ((random 1) <= (1 / _step)) then{
		_finalRoads pushBack _x;
	};
}forEach _suitableRoads;

_count = count _finalRoads;

{
	_road = _x select 0;
	_connected = roadsConnectedTo _road;

	_dir = [_road,_connected select (floor random(count _connected))] call BIS_fnc_dirTo;
	if (random 1 >= 0.5) then{_dir = _dir + 180};

	_pos = getPosATL _road;

	if ((count (_pos nearEntities ["Car", _minCarDist]) == 0 || (random 1) < _extraChance) && (random 1) > _chanceToSkip) then{
		_roadCheckCounter = 0;
		while{isOnRoad _pos && _roadCheckCounter < 100}do{
			_pos = [_pos,0.1,_dir + 90] call BIS_fnc_relPos;
			_roadCheckCounter = _roadCheckCounter + 1;
		};
		if !(isOnRoad _pos) then{
			_vehicle = [([_pos,0.5,_dir - 90] call BIS_fnc_relPos),_dir,pvpfw_ambient_spawnableCivCars call BIS_fnc_selectRandom] call _createVehicle;
		};
	};
	if(pvpfw_ambient_debugMode)then{systemChat format["road check: %1 / %2",_forEachIndex,_count - 1];};
	sleep 0.01;
}forEach _finalRoads;

[] spawn{
	sleep 2;

	{
		_veh = _x;
		_pos = getPosATL _x;
		if (!alive _veh) then{
			deleteVehicle _veh;
			pvpfw_ambient_allVehicles set[_forEachIndex,objNull];
			{
				_x setDamage 0;
			}forEach (_pos nearObjects 25);
		};
		sleep 0.01;
	}forEach pvpfw_ambient_allVehicles;
	pvpfw_ambient_allVehicles = pvpfw_ambient_allVehicles - [objNull];
};


// Helicopters

{
	if (typeOf _x != "Land_JumpTarget_F") then{
		[getPosATL _x,direction _x,pvpfw_ambient_spawnableChoppers call BIS_fnc_selectRandom] call _createVehicle;

		sleep 0.1;

		_emptyPosition = (getPosATL _x) findEmptyPosition [0,20,"Land_Cargo_HQ_V3_F"];
		if (count _emptyPosition != 0) then{
			[_emptyPosition,random 360,pvpfw_ambient_spawnableMilCars call BIS_fnc_selectRandom] call _createVehicle;
		};
	};
}forEach ([0,0,0] nearObjects ["Helipad_base_F",100000]);

if(pvpfw_ambient_debugMode)then{
	systemChat format["vehicle count: %1",count pvpfw_ambient_allVehicles];
	systemChat format["Chopper count: %1",count pvpfw_ambient_allChoppers];
};

pvpfw_curator_admin addCuratorEditableObjects [pvpfw_ambient_allVehicles + pvpfw_ambient_allChoppers,true];
