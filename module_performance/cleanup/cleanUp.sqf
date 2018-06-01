
scriptName "pvpfw_cleanUp";

pvpfw_perf_cleanUpAllExplosives = missionNamespace getVariable["pvpfw_perf_cleanUpAllExplosives",[]];
pvpfw_perf_allWeaponHolders = missionNamespace getVariable["pvpfw_perf_allWeaponHolders",[]];

"pvpfw_pv_perf_cleanUpThisContainer" addPublicVariableEventhandler{
	_varValue = _this select 1;
	pvpfw_perf_allWeaponHolders pushBack _varValue;
};

"pvpfw_pv_perf_cleanUpThisPutObject" addPublicVariableEventhandler{
	_varValue = _this select 1;
	pvpfw_perf_cleanUpAllExplosives pushBack _varValue;
};

while {true} do{
	{
		_unit = _x;

		_nearEntities = (getPosATL _unit) nearEntities [["CAManBase","Air","LandVehicle"],pvpfw_perf_cleanUpWeaponholdersResetRadius];

		{
			if ((count crew _x) == 0) then{
				_nearEntities set[_forEachIndex,objNull];
			};
		}forEach _nearEntities;
		_nearEntities = _nearEntities - [objNull];

		if (count _nearEntities == 0) then{
			_cleanupInitTime = _unit getVariable["pvpfw_cleanup_InitTime",0];
			if (_cleanupInitTime == 0) then{
				_unit setVariable ["pvpfw_cleanup_InitTime",diag_tickTime,false];
			}else{
				if (diag_tickTime > (_cleanupInitTime + pvpfw_perf_cleanUpWeaponholdersTimer)) then{
					diag_log format["DEBUG -> perf_cleanUp: deleting weaponholder %1 | init = %2, cleanedAfter = %3m",_unit,_cleanUpInitTime,round ((diag_tickTime - _cleanUpInitTime)/60)];
					deleteVehicle _unit;
				};
			};
		}else{
			_unit setVariable ["pvpfw_cleanup_InitTime",0,false];
		};

		sleep 0.1;
	}forEach pvpfw_perf_allWeaponHolders;
	pvpfw_perf_allWeaponHolders = pvpfw_perf_allWeaponHolders - [objNull];
	sleep 0.1;

	{
		_unit = _x;

		_cleanupInitTime = _unit getVariable["pvpfw_cleanup_InitTime",0];
		if (_cleanupInitTime == 0)then{
			_unit setVariable["pvpfw_cleanup_InitTime",diag_tickTime,false];
			_cleanupInitTime = diag_tickTime;
		};

		if (diag_tickTime > (_cleanupInitTime + pvpfw_perf_cleanUpExplosivesMaxTimer)) then{
			deleteVehicle _unit;
		}else{
			_nearEntities = (getPosATL _unit) nearEntities [["CAManBase","Air","LandVehicle"],pvpfw_perf_cleanUpExplosivesRadius];
			{
				if ((count crew _x) == 0) then{
					_nearEntities set[_forEachIndex,objNull];
				};
			}forEach _nearEntities;
			_nearEntities = _nearEntities - [objNull];

			if (count _nearEntities == 0) then{
				_cleanupResetTime = _unit getVariable["pvpfw_cleanup_ResetTime",0];
				if (_cleanupResetTime == 0) then{
					_unit setVariable ["pvpfw_cleanup_ResetTime",diag_tickTime,false];
				}else{
					if (diag_tickTime > (_cleanupResetTime + pvpfw_perf_cleanUpExplosivesMinTimer)) then{
						diag_log format["DEBUG -> perf_cleanUp: deleting explosive %1 | init = %2, cleanedAfter = %3m",_unit,_cleanupInitTime,round ((diag_tickTime - _cleanupInitTime)/60)];
						deleteVehicle _unit;
					};
				};
			}else{
				_unit setVariable ["pvpfw_cleanup_ResetTime",0,false];
			};
		};

		sleep 0.1;
	}forEach pvpfw_perf_cleanUpAllExplosives;
	pvpfw_perf_cleanUpAllExplosives = pvpfw_perf_cleanUpAllExplosives - [objNull];
	sleep 0.1;

	{
		_unit = _x;

		if (!alive _unit)then{
			//get an array of all entities surrounding the wreck (but remove vehicles without crew from the list of valid vehicles, that would prevent the cleanup)
			_nearEntities = (getPosATL _unit) nearEntities [["CAManBase","Air","LandVehicle"],pvpfw_perf_cleanUpVehicleRadius];

			{
				if ((count crew _x) == 0) then{
					_nearEntities set[_forEachIndex,objNull];
				};
			}forEach _nearEntities;
			_nearEntities = _nearEntities - [objNull];

			//if _nearEntities empty then initiate cleanup procedure
			if (count _nearEntities == 0) then{
				_cleanupInitTime = _unit getVariable["pvpfw_cleanup_InitTime",0];
				if (_cleanupInitTime == 0) then{
					_unit setVariable ["pvpfw_cleanup_InitTime",diag_tickTime,false];
				}else{
					if (diag_tickTime > (_cleanupInitTime + pvpfw_perf_cleanUpVehicleTimer)) then{
						diag_log format["DEBUG -> perf_cleanUp: deleting destroyed vehicle %1 | init = %2, cleanedAfter = %3",_unit,_cleanUpInitTime,diag_tickTime - _cleanUpInitTime];
						deleteVehicle _unit;
					};
				};
			}else{
				_unit setVariable ["pvpfw_cleanup_InitTime",0,false];
			};
		};

		sleep 0.1;
	}forEach vehicles;

	sleep 0.1;
};
