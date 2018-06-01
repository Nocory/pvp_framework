if (player != (vehicle player) || !alive player) exitWith{};

// Change ownership of all local vehicles to the server, so that preview objects wont move them (or just disable collision ???)
pvpfw_pv_constr_changeOwnership = [];
{
	if (local _x)then{
		pvpfw_pv_constr_changeOwnership pushBack _x;
	};
}forEach vehicles;

publicVariableServer "pvpfw_pv_constr_changeOwnership";

// Script Cleanup in case of hotreload
deleteVehicle (missionNamespace getVariable["pvpfw_constr_previewObject",objNull]);
deleteVehicle (missionNamespace getVariable["pvpfw_constr_helperObject",objNull]);
deleteVehicle (missionNamespace getVariable["pvpfw_constr_boundingHelper1",objNull]);
deleteVehicle (missionNamespace getVariable["pvpfw_constr_boundingHelper2",objNull]);

sleep 0.5;

pvpfw_constr_previewObject = ((pvpfw_wg_assets_spawnInfo select 0) select 1) createVehicleLocal [0,0,0];
pvpfw_constr_helperObject = "Sign_Sphere10cm_F" createVehicleLocal [0,0,0];
pvpfw_constr_boundingHelper1 = "Sign_Pointer_Green_F" createVehicleLocal [0,0,0];
pvpfw_constr_boundingHelper2 = "Sign_Pointer_Blue_F" createVehicleLocal [0,0,0];

pvpfw_constr_helperObject hideObject true;
pvpfw_constr_boundingHelper1 hideObject true;
pvpfw_constr_boundingHelper2 hideObject true;

["pvpfw_fnc_constr_clickedBuild","onEachFrame",{
	if (!alive player || player != (vehicle player)) exitWith{
		[] call pvpfw_fnc_constr_stopConstruction;
	};

	_objInfo = pvpfw_wg_assets_spawnInfo select 0;

	_objectBuildDist = _objInfo select 3;
	_customDir = _objInfo select 4;
	_buildFlat = _objInfo select 5;

	_initPos = [getPosATL player,_objectBuildDist,direction player] call BIS_fnc_relPos;
	_buildPos = getPosASL pvpfw_constr_previewObject;

	pvpfw_constr_previewObject setDir ((direction player) + _customDir);

	_helperStartPos = [_initPos select 0,_initPos select 1,((getPosASL player) select 2) + 1];

	pvpfw_constr_helperObject setPosASL _helperStartPos;

	_checkX = _helperStartPos select 0;
	_checkY = _helperStartPos select 1;
	_checkZ = _helperStartPos select 2;

	_zCheckDist = 0;
	_zMax = 2;

	_updateIntersectingObjects = {
		private ["_tempIntersectArr"];
		_tempIntersectArr = lineIntersectsWith [_helperStartPos,[_checkX,_checkY,(_this select 0)],pvpfw_constr_previewObject,pvpfw_constr_helperObject];
		{
			if ((_x getVariable ["pvpfw_constr_objCost",-1]) != -1)then{
				_tempIntersectArr set[_forEachIndex,objNull];
			};
		}forEach _tempIntersectArr;

		_tempIntersectArr - [objNull]
	};

	_intersectingObj = [_checkZ - _zMax] call _updateIntersectingObjects;

	// ["House","HouseBase","NonStrategic","Building","Static","All"]
	// ["Land_HBarrier_large","NonStrategic","Building","Static","All"]

	_builtOn = objNull;

	if (({_x isKindOf "Building"}count _intersectingObj) != 0) then{
		while{
			(0 == (count ([_checkZ - _zCheckDist] call _updateIntersectingObjects)))
			&&
			(_zCheckDist < _zMax)
		}do{
			_zCheckDist = _zCheckDist + 0.05;
		};

		_builtOn = _intersectingObj select 0;

		if (_zCheckDist == 0)exitWith{};

		_buildPos = getPosASL pvpfw_constr_helperObject;
		_buildPos set[2,(_buildPos select 2) - _zCheckDist];
		//pvpfw_constr_previewObject setVectorUp (vectorUp _builtOn);
		pvpfw_constr_previewObject setPosASL _buildPos;
	}else{
		if !(_buildFlat) then{
			_boundingBox = boundingBoxReal pvpfw_constr_previewObject;

			_precision = 4;

			_combinedSurfaceNormal = [0,0,0];
			_combinedHeight = 0;

			_counter = 0;

			_bbX = ((_boundingBox select 1) select 0);
			_bbY = ((_boundingBox select 1) select 1);

			_startPos = [_initPos,_bbX,(direction pvpfw_constr_previewObject) - 90] call BIS_fnc_relPos;
			_startPos = [_startPos,_bbY,(direction pvpfw_constr_previewObject) + 180] call BIS_fnc_relPos;

			_debugPos = +_startPos;
			_debugPos set[2,2];
			pvpfw_constr_boundingHelper1 setPosATL _debugPos;

			_checkPos = [0,0,0];
			_checkPos2 = [0,0,0];

			for "_i" from 0 to _precision do{
				_checkPos = [_startPos,(_bbX * 2) / _precision * _i,(direction pvpfw_constr_previewObject) + 90] call BIS_fnc_relPos;
				for "_j" from 0 to _precision do{
					_checkPos2 = [_checkPos,(_bbY * 2) / _precision * _j,direction pvpfw_constr_previewObject] call BIS_fnc_relPos;
					_combinedSurfaceNormal = _combinedSurfaceNormal vectorAdd (surfaceNormal _checkPos2);
					_combinedHeight = _combinedHeight + (getTerrainHeightASL _checkPos2);
					_counter = _counter + 1;
				};
			};

			_debugPos = +_checkPos2;
			_debugPos set[2,2];
			pvpfw_constr_boundingHelper2 setPosATL _debugPos;

			_result = _combinedSurfaceNormal vectorMultiply (1 / _counter);

			pvpfw_constr_previewObject setVectorUp _result;
			_buildPos = [_initPos select 0,_initPos select 1,(_combinedHeight / _counter)];
			pvpfw_constr_previewObject setPosASL _buildPos;
		}else{
			_buildPos = [_initPos select 0,_initPos select 1,(getTerrainHeightASL _initPos)];
			pvpfw_constr_previewObject setPosASL _buildPos;
		};
	};

	pvpfw_wg_assets_spawnInfo set[1,_buildPos];
	pvpfw_wg_assets_spawnInfo set[2,[vectorDir pvpfw_constr_previewObject,vectorUp pvpfw_constr_previewObject]];
	pvpfw_wg_assets_spawnInfo set[3,_builtOn];
}] call BIS_fnc_addStackedEventHandler;
