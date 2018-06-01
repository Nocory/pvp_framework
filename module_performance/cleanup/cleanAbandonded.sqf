
scriptName "pvpfw_cleanAbandoned";

private["_checkAbandonded","_isAbandonded","_abandondedSince"];

_checkAbandonded = {
	private["_vehicle","_nearEntities","_cleanThis"];
	_vehicle = _this;
		
	_cleanThis = true;
	
	{
		if (_vehicle distance (markerPos _x) <= pvpfw_perf_cleanUpDontCleanUpAroundDistance) exitWith{
			_cleanThis = false;
		};
	}forEach pvpfw_perf_cleanUpDontCleanUpAroundMarkers;
	
	if (_cleanThis) then{
		_nearEntities = (position _vehicle) nearEntities [["LandVehicle","Air","Ship","CAManBase"], pvpfw_perf_cleanUpAbandonedRadius];
		if (({(count crew _x) != 0} count _nearEntities) != 0) then{
			_cleanThis = false;
		};
	};
	
	_cleanThis
};

while{true}do{
	_vehiclesToCheck = [];
	
	if (count pvpfw_perf_cleanUpOnlyTheseTypes != 0)then{
		{
			if (typeOf _x in pvpfw_perf_cleanUpOnlyTheseTypes)then{
				_vehiclesToCheck pushBack _x;
			};
			sleep 0.05;
		}forEach vehicles;
	}else{
		_vehiclesToCheck = vehicles;
	};

	
	sleep 0.1;
	
	{
		if (!isNull _x && {alive _x} && {(faction _x) in pvpfw_perf_cleanUpAbandonedFromFaction})then{
			_isAbandonded = (_x call _checkAbandonded);
			if (_isAbandonded) then{
				_abandondedSince = _x getVariable ["pvpfw_respawn_abandondedSince",0];
				if (_abandondedSince == 0) then{
					_x setVariable ["pvpfw_respawn_abandondedSince",diag_tickTime,false];
				}else{
					if (diag_tickTime > (_abandondedSince + pvpfw_perf_CleanUpAbandondTimer)) then{
						deleteVehicle _x;
						diag_log format["#PVPFW module_cleanup: cleaned up abandonded vehicle %1",typeOf _x];
					};
				};
			}else{
				_x setVariable ["pvpfw_respawn_abandondedSince",0,false];
			};
		};
		sleep 0.13;
	}forEach _vehiclesToCheck;
	
	sleep 1.2;
};