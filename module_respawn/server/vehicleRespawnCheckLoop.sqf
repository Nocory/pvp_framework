//DESTR_TIME,_vehicle,_type,_pos,_dir,_respawnTime,_vehicleIdentifier,_customFaction,_isCV

scriptName "pvpfw_vehicleRespawnCheck";

sleep 0.1;

// array is:
// 0: destrTime
// 1: vehicleObject
// 2: classType
// 3: respawnPos
// 4: respawnDir
// 5: respawnDelay
// 6: setVariables

while{true}do{
	{
		_array = _x;
		_vehicle = _array select 1;

		if (!alive _vehicle || isNull _vehicle) then{
			_destrTime = _array select 0;
			if (_destrTime == 0) then{
				_array set[0,diag_tickTime];
				[format["Respawning %1 in %2",(_array select 2),(_array select 5)],3] call pvpfw_fnc_log_show;
			}else{
				_delay = _array select 5;
				if (diag_tickTime > (_destrTime + _delay)) then{
					_type = _array select 2;
					_pos = _array select 3;
					_dir = _array select 4;

					_nearestObjects = nearestObjects [_pos, [], 20];
					{
						if (!alive _x) then{
							deleteVehicle _x;
						};
					}forEach _nearestObjects;

					sleep 0.25;

					_vehicle = createVehicle [_type, [random 500,random 500,4500 + (random 500)], [], 0, "CAN_COLLIDE"];
					[format["Respawning %1 now",_type],3] call pvpfw_fnc_log_show;
					_vehicle setDir _dir;
					_vehicle setPos _pos;

					sleep 0.1;

					_vehicle setVelocity[0,0,1];

					sleep 0.5;

					_allVars = _array select 6;
					{
						_vehicle setVariable _x;
					}forEach _allVars;

					{
						_vehicle setObjectTextureGlobal [_x select 0,_x select 1];
					}forEach (_vehicle getVariable["pvpfw_customTexture",[]]);

					_vehicle disableTIEquipment true;
					clearMagazineCargoGlobal _vehicle;
					clearWeaponCargoGlobal _vehicle;
					clearItemCargoGlobal _vehicle;
					clearBackpackCargoGlobal _vehicle;

					_array set[0,0];
					_array set[1,_vehicle];

					pvpfw_curator_admin addCuratorEditableObjects [[_vehicle],false];

					//["pvpfw_wargames_server_init",[_vehicle]] call pvpfw_fnc_events_callEH;

					sleep 0.5;

					_vehicle setVariable ["pvpfw_marker_readyToCreate",true,true];
				};
			};
		};
		sleep 0.1;
	}forEach pvpfw_respawn_vehicles;
	sleep 0.1;
};
