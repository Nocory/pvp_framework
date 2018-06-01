if (!isNil "pvpfw_template_allBuilt") then{
	{
		deleteVehicle _x;
	}forEach pvpfw_template_allBuilt;
};

pvpfw_template_allBuilt = [];

_delay = if (isMultiplayer) then{0.05}else{0};

_counter = 0;
_array = ["pvpfw_template", "missionObjects", "index" + str(_counter), "ARRAY"] call iniDB_read;
while{count _array != 0 && _counter < 1000}do{
	_object = createVehicle [(_array select 0), [random 100, random 100, 5000], [], 0, "CAN_COLLIDE"];
	sleep _delay;
	_object setVariable ["pvpfw_noRespawn",true,false];
	_object setVariable ["pvpfw_customFaction","CIV_F",true];
	_object setVectorDirAndUp (_array select 2);
	sleep _delay;
	_pos = call compile (_array select 1);
	_object setPosASL _pos;
	sleep _delay;	
	pvpfw_template_allBuilt pushBack _object;
	
	_counter = _counter + 1;
	_array = ["pvpfw_template", "missionObjects", "index" + str(_counter), "ARRAY"] call iniDB_read;
};

systemChat format["Template: Added %1 mission objects",count pvpfw_template_allBuilt];

pvpfw_curator_admin addCuratorEditableObjects [pvpfw_template_allBuilt,true];

_counter = 0;
{
	_object = _x;
	if (_object isKindOf "Strategic" || _object isKindOf "House" || _object isKindOf "Wall")then{
		_marker = format["pvpfw_template_initialObj_%1",_counter];
		createMarkerLocal [_marker, getPosATL _object];
		_marker setMarkerDirLocal (direction _object);
		_size = (boundingBoxReal _object) select 1;
		_size resize 2;
		_marker setMarkerSizeLocal _size;
		_marker setMarkerShapeLocal "RECTANGLE";
		_marker setMarkerColorLocal "ColorGrey";
		_marker setMarkerBrushLocal "SolidFull";
		_marker setMarkerAlpha 1;
		
		_counter = _counter + 1;
	};
}forEach pvpfw_template_allBuilt;

systemChat format["Template: Created %1 markers",_counter];

/*
[] execVM "module_templates\missionObjects.sqf";
*/