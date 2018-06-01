
// wip wip wip
// as always

pvpfw_fnc_template_vehicleSpawners = compile preprocessFileLineNumbers "module_templates\vehicleSpawners.sqf";

{
	deleteVehicle _x;
}forEach (missionNamespace getVariable["pvpfw_template_spawnedObjects",[]]);

pvpfw_template_spawnedObjects = [];

[[],pvpfw_fnc_template_vehicleSpawners,"pvpfw_fnc_template_vehicleSpawners"] call pvpfw_fnc_spawnOnce;

/*

if (!isNil "pvpfw_template_spawnedObjects")then{
	{
		deleteVehicle _x;
	}forEach pvpfw_template_spawnedObjects;
	pvpfw_template_spawnedObjects resize 0;
}else{
	pvpfw_template_spawnedObjects = [];

	pvpfw_fnc_template_farp = compile preprocessFileLineNumbers "module_templates\farp.sqf";
	pvpfw_fnc_template_crate = compile preprocessFileLineNumbers "module_templates\crate.sqf";
	pvpfw_fnc_template_chopperBarriers = compile preprocessFileLineNumbers "module_templates\chopperBarriers.sqf";
};

pvpfw_fnc_getZeusObjects = {
	["pvpfw_template","missionObjects_BACKUP"] call iniDB_deletesection;

	_counter = 0;
	_array = ["pvpfw_template", "missionObjects", "index" + str(_counter), "ARRAY"] call iniDB_read;
	while{count _array != 0 && _counter < 1000}do{
		["pvpfw_template", "missionObjects_BACKUP", "index" + str(_counter), _array] call iniDB_write;
		_counter = _counter + 1;
		_array = ["pvpfw_template", "missionObjects", "index" + str(_counter), "ARRAY"] call iniDB_read;
	};

	["pvpfw_template","missionObjects"] call iniDB_deletesection;

	_counter = 0;
	{
		_vectorDir = vectorDir _x;
		_vectorUp = vectorUp _x;
		_x setVectorUp [0,0,1];
		_x setVectorDir [0,1,0];
		["pvpfw_template", "missionObjects", "index" + str(_forEachIndex), [typeOf _x,(getPosASL _x) call pvpfw_fnc_core_posToString, [_vectorDir,_vectorUp]]] call iniDB_write;
		_x setVectorDirAndUp [_vectorDir,_vectorUp];
		_counter = _counter + 1;
	}forEach (curatorEditableObjects ([_this,0,pvpfw_curator_admin] call BIS_fnc_param));

	hintSilent format["Saved %1 Objects",_counter];
	systemChat format["Saved %1 Objects",_counter];
};

//[[],"module_templates\missionObjects.sqf","template_missionObjects"] call pvpfw_fnc_spawn;
//[] call pvpfw_fnc_template_chopperBarriers;
[] call pvpfw_fnc_template_crate;
