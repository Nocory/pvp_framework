private["_vehIdentArray","_vehicle","_type","_allVehicleVars","_respawnDelay","_typeCount","_pos","_dir"];

_vehIdentArray = [];

{
	_vehicle = _x;
	_type = typeOf _vehicle;

	// Handle Vars //
	_allVehicleVars = _vehicle getVariable ["pvpfw_allVariables",[]];
	{
		_vehicle setVariable _x;
	}forEach _allVehicleVars;

	// Check delay to use for respawn (60 if cv, otherwise check for custom respawn delay or assume -1 if neither)//
	_respawnDelay = if (_vehicle getVariable["pvpfw_vehicleIsCV",false]) then[{60},{_vehicle getVariable["pvpfw_respawnDelay",-1]}];

	if (_respawnDelay == -1)then{
		{
			if (_type isKindOf (_x select 0)) exitWith{_respawnDelay = _x select 1};
		}forEach pvpfw_respawn_typesToRespawn;
	};

	if (_respawnDelay != -1) then{
		{
			if (_type isKindOf _x) exitWith{_respawnDelay = -1};
		}forEach pvpfw_respawn_exemptFromRespawn;
	};

	// Check and set custom camo //
	{
		_vehicle setObjectTextureGlobal [_x select 0,_x select 1];
	}forEach (_vehicle getVariable["pvpfw_customTexture",[]]);

	// Prepare cargo and equipment //
	clearMagazineCargoGlobal _vehicle;
	clearWeaponCargoGlobal _vehicle;
	clearItemCargoGlobal _vehicle;
	clearBackpackCargoGlobal _vehicle;
	_vehicle disableTIEquipment true;

	// Final check if vehicle should be made respawnable //
	if (_vehicle getVariable ["pvpfw_noRespawn",false] || _respawnDelay == -1) exitWith{};

	// Get Vehicle Identifier
	if (!(_vehicle getVariable["pvpfw_vehicleIsCV",false]) && (_type isKindOf "Wheeled_APC_F" || _type isKindOf "Helicopter" || _type isKindOf "Tank_F" || _type in ["B_MRAP_01_hmg_F","O_MRAP_02_hmg_F"]))then{
		_typeCount = {_x == _type} count _vehIdentArray;
		_vehIdentArray pushBack _type;
		if (_typeCount < (count pvpfw_common_alphabet)) then{
			_vehicleIdentifier = ("_" + (pvpfw_common_alphabet select _typeCount));
			_allVehicleVars pushBack ["pvpfw_vehicleIdentifier",_vehicleIdentifier,true];
			_vehicle setVariable ["pvpfw_vehicleIdentifier",_vehicleIdentifier,true];
		};
	};

	// Lower respawn time if training mode is enabled
	if (pvpfw_param_trainingEnabled == 1) then{_respawnDelay = 5};

	// Get Position and Direction //
	_pos = getPos _vehicle;
	_dir = direction _vehicle;

	// Add to the array of respawnable vehicles

	pvpfw_respawn_vehicles pushBack [0,_vehicle,_type,_pos,_dir,_respawnDelay,_allVehicleVars];
	diag_log format["#PVPFW module_respawn: setting respawn for %1, delay: %2",_type,_respawnDelay];

	_vehicle setVariable ["pvpfw_marker_readyToCreate",true,true];
}forEach vehicles;
