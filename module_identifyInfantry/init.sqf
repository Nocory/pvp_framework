/****************************************
Description:
Lets a player identify other (friendly) units by name, when looking at them.
****************************************/

if (isDedicated) exitWith{};

call compile preProcessFileLineNumbers "module_identifyInfantry\dogtags.sqf";
call compile preProcessFileLineNumbers "module_identifyInfantry\vehicleCrew.sqf";

// TODO change script to use custom faction instead of sides and playerSide

[[],{
	scriptName "pvpfw_ii_getUnitsFor3DText";

	// *** HOT-RELOAD CLEANUP BEGIN
	removeMissionEventHandler ["Draw3D",missionNamespace getVariable["pvpfw_ii_missionEH",-1]];
	{
		(_x select 0) setVariable["pvpfw_3dNameSet",false,false];
		deleteVehicle (_x select 2);
	}forEach ((missionNamespace getVariable["pvpfw_ii_array",[]]) - [objNull]);
	// *** HOT-RELOAD CLEANUP END

	private["_unit","_sphere","_addRange","_displayRange"];

	_addRange = 30;
	pvpfw_ii_displayRange = _addRange - 10;

	//waitUntil{sleep 0.1;pvpfw_playerReadyToMove};
	waitUntil{sleep 0.1;true};

	pvpfw_ii_array = [];
	pvpfw_ii_arrayFinal = [];

	pvpfw_ii_reportPerfEvery = 5;
	pvpfw_ii_nextReport = diag_tickTime;
	pvpfw_ii_totalDrawTime = 0;
	pvpfw_ii_drawCounter = 0;
	pvpfw_ii_drawTimePerFrame = 0;

	pvpfw_ii_missionEH = addMissionEventHandler ["Draw3D",{
		_initTime = diag_tickTime;

		{
			_unit = _x select 0;
			_name = _x select 1;
			_sphere = _x select 2;

			if (!lineIntersects [eyePos player, eyePos _unit] && _unit == vehicle _unit) then{
				drawIcon3D ["\a3\ui_f\data\map\markers\nato\b_inf.paa", [1,1,1,1 - ((((player distance _unit) max pvpfw_ii_displayRange) - pvpfw_ii_displayRange) / 5)], ASLtoATL visiblePositionASL _sphere, 0, 0, 0, _name, 2, 0.03,"PuristaMedium"];
			};
		}forEach pvpfw_ii_arrayFinal;

		_drawTime = diag_tickTime - _initTime;
		pvpfw_ii_totalDrawTime = pvpfw_ii_totalDrawTime + _drawTime;
		pvpfw_ii_drawCounter = pvpfw_ii_drawCounter + 1;

		if (diag_tickTime >= pvpfw_ii_nextReport)then{
			pvpfw_ii_drawTimePerFrame = (pvpfw_ii_totalDrawTime / pvpfw_ii_drawCounter) * 1000;
			pvpfw_ii_nextReport = diag_tickTime + pvpfw_ii_reportPerfEvery;
			pvpfw_ii_totalDrawTime = 0;
			pvpfw_ii_drawCounter = 0;
		};
	}];

	_lastVehicle = objNull;

	_suitableSides = if (playerSide == independent) then{
		[independent,blufor,opfor]
	}else{
		[playerSide,independent]
	};

	while{true}do{
		{
			_unit = _x select 0;
			if (player distance _unit > _addRange || !alive _unit || _unit != vehicle _unit) then{
				deleteVehicle (_x select 2);
				pvpfw_ii_array set[_forEachIndex,objNull];
				_unit setVariable["pvpfw_3dNameSet",false,false];
			};
			sleep 0.05;
		}forEach pvpfw_ii_array;

		sleep 0.04;

		pvpfw_ii_array = pvpfw_ii_array - [objNull];

		sleep 0.04;

		{
			if (!(_x getVariable["pvpfw_3dNameSet",false]) && {(side _x) in _suitableSides} && {_x == vehicle _x}) then{
				//_name = _x getVariable["pvpfw_markers_shortName",""];
				_name = _x getVariable["pvpfw_markers_shortName",name _x];
				if (_name != "") then{
					_sphere = "Sign_Sphere10cm_F" createVehicleLocal (getPosATL _x);
					hideObject _sphere;
					_sphere attachto [_x,[0,0,0.5], "head"];
					pvpfw_ii_array pushback [_x,_name,_sphere];
					_x setVariable["pvpfw_3dNameSet",true,false];
				};
			};
			sleep 0.05;
		}forEach (((getPosATL player) nearEntities ["CAManBase", _addRange]) - [player]);

		sleep 0.107;

		pvpfw_ii_arrayFinal = + pvpfw_ii_array;
	};
},"pvpfw_ii_getUnitsFor3DText"] call pvpfw_fnc_spawnOnce;
