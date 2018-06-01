
/*
_createSandbagsAroundChopper = {
	private["_dirFrom","_pos","_sandBagpos"];
	_dirFrom = _this select 0;
	_pos = _this select 1;

	{
		_sandBagpos = [_pos,4.5,_dirFrom + _x] call BIS_fnc_relPos;
		_sandBagpos set[2,0];
		_object = createVehicle ["Land_BagFence_Long_F", [random 1000, random 1000, 500 + random(500)], [], 0, "CAN_COLLIDE"];
		_object setDir _dirFrom;
		_object setPosATL _sandBagpos;
		_object setVectorUp (surfaceNormal _sandBagpos);

		pvpfw_template_spawnedObjects pushBack _object;
	}forEach [-90,90];
};

private["_pos","_object","_dir","_dirFrom","_sandbagPos"];
{
	if (_x isKindOf "Helicopter") then{
		_pos = getPosATL _x;
		_pos set[2,0];
		_object = createVehicle ["Land_HelipadSquare_F", _pos, [], 0, "CAN_COLLIDE"];
		_dir = direction _x;
		_object setDir _dir;

		for "_i" from 0 to 270 step 90 do{
			_dirFrom = _i + _dir;
			_sandbagPos = [_pos,6,_dirFrom] call BIS_fnc_relPos;
			[_dirFrom,_sandbagPos] call _createSandbagsAroundChopper;
		};
	};
}forEach vehicles;
*/

//////////////

_createBarriers = {
  private["_spawnerObject"];
  _spawnerObject = _this select 0;
  _spawnerDir = direction _spawnerObject;
  _spawnerPos = [getPosATL _spawnerObject,-5,_spawnerDir] call BIS_fnc_relPos;
  for "_i" from 90 to 270 step 45 do {

    _barrierPos = [_spawnerPos,12,_spawnerDir + _i] call BIS_fnc_relPos;
		_barrierPos set[2,0];

		_barrier = createVehicle ["Land_HBarrier_5_F", [random 1000, random 1000, 500 + random(500)], [], 0, "CAN_COLLIDE"];
		_barrier setDir (_spawnerDir + _i);
		_barrier setPosATL _barrierPos;
		_barrier setVectorUp (surfaceNormal _barrierPos);
    pvpfw_template_spawnedObjects pushBack _barrier;

    if((_i % 90) != 0)then{
      _flag = createVehicle ["Flag_White_F", [random 1000, random 1000, 500 + random(500)], [], 0, "CAN_COLLIDE"];
  		_flag setDir (_spawnerDir + _i);
      _flagPos = +_barrierPos;
      _flagPos set[2,-4];
  		_flag setPosATL _flagPos;
      pvpfw_template_spawnedObjects pushBack _flag;
    };

    sleep 0.05;
  };

  {
    _spawnerPos = [getPosATL _spawnerObject,5,_spawnerDir] call BIS_fnc_relPos;
    _barrierPos = [_spawnerPos,12,_spawnerDir + _x] call BIS_fnc_relPos;
		_barrierPos set[2,0];

		_barrier = createVehicle ["Land_HBarrier_5_F", [random 1000, random 1000, 500 + random(500)], [], 0, "CAN_COLLIDE"];
		_barrier setDir (_spawnerDir + _x);
		_barrier setPosATL _barrierPos;
		_barrier setVectorUp (surfaceNormal _barrierPos);
    pvpfw_template_spawnedObjects pushBack _barrier;

    _flag = createVehicle ["Flag_White_F", [random 1000, random 1000, 500 + random(500)], [], 0, "CAN_COLLIDE"];
		_flag setDir (_spawnerDir + _x);
    _flagPos = +_barrierPos;
    _flagPos set[2,-4];
    _flag setPosATL _flagPos;
    pvpfw_template_spawnedObjects pushBack _flag;

    sleep 0.05;
  }forEach[90,270];
};

{
  _i = 1;
  while{!isNil ("pvpfw_wg_vehicleSpawner_" + _x + "_" + str(_i))}do{
    _spawner = "pvpfw_wg_vehicleSpawner_" + _x + "_" + str(_i);

    _spawnerObject = missionNamespace getVariable[_spawner,objNull];
    [_spawnerObject] call _createBarriers;

    _i = _i + 1;
  };
}forEach["blu","red"];
