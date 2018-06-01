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