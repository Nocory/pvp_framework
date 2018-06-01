
scriptName "pvpfw_recordBattle";

pvpfw_recordingInterval = 3;
pvpfw_nextRecording = ceil(diag_tickTime + pvpfw_recordingInterval);
if (isNil "pvpfw_record_count") then{pvpfw_record_count = 0;};
pvpfw_record_step = 1;

["pvpfw_record", "onEachFrame", {
	if (diag_tickTime < pvpfw_nextRecording)exitWith{};
	if (!pvpfw_active)exitWith{
		["pvpfw_record", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
	};
	switch(pvpfw_record_step)do{
		// Blufor
		case(1):{
			_bluUnits = [];
			{
				_bluUnits pushBack (getPosASL _x);
				true
			}count (entities "SoldierWB");
			missionNamespace setVariable[format["pvpfw_record_blu_%1",pvpfw_record_count],_bluUnits];
			pvpfw_record_step = pvpfw_record_step + 1;
		};
		// Opfor
		case(2):{
			_redUnits = [];
			{
				_redUnits pushBack (getPosASL _x);
				true
			}count (entities "SoldierEB");
			missionNamespace setVariable[format["pvpfw_record_red_%1",pvpfw_record_count],_redUnits];
			pvpfw_record_step = pvpfw_record_step + 1;
		};
		// Helicopters
		case(3):{
			_bluUnits = [];
			_redUnits = [];
			{
				_arr = getPosASL _x;
				_arr set[2,direction (vehicle _x)];
				switch(_x getVariable["pvpfw_customFaction",faction _x])do{
					case("BLU_F"):{
						_bluUnits pushBack _arr;
					};
					case("OPF_F"):{
						_redUnits pushBack _arr;
					};
				};
				true
			}count (entities "Air");
			missionNamespace setVariable[format["pvpfw_record_air_%1",pvpfw_record_count],[_bluUnits,_redUnits]];
			pvpfw_record_step = pvpfw_record_step + 1;
		};
		// Cars + APCs
		case(4):{
			_bluCar = [];
			_redCar = [];
			_bluAPC = [];
			_redAPC = [];
			_bluCV = [];
			_redCV = [];
			{
				_arr = getPosASL _x;
				_arr set[2,direction (vehicle _x)];
				switch(_x getVariable["pvpfw_customFaction",faction _x])do{
					case("BLU_F"):{
						if (_x isKindOf "Wheeled_APC_F")then{
							if (_x getVariable ["pvpfw_vehicleIsCV",false])then{
								_bluCV pushBack _arr;
							}else{
								_bluAPC pushBack _arr;
							};
						}else{
							_bluCar pushBack _arr;
						};
					};
					case("OPF_F"):{
						if (_x isKindOf "Wheeled_APC_F")then{
							if (_x getVariable ["pvpfw_vehicleIsCV",false])then{
								_redCV pushBack _arr;
							}else{
								_redAPC pushBack _arr;
							};
						}else{
							_redCar pushBack _arr;
						};
					};
				};
				true
			}count (entities "Car_F");
			missionNamespace setVariable[format["pvpfw_record_car_%1",pvpfw_record_count],[_bluCar,_redCar]];
			missionNamespace setVariable[format["pvpfw_record_apc_%1",pvpfw_record_count],[_bluAPC,_redAPC]];
			missionNamespace setVariable[format["pvpfw_record_cv_%1",pvpfw_record_count],[_bluCV,_redCV]];
			pvpfw_record_step = pvpfw_record_step + 1;
		};
		// Default + Remove
		default{
			pvpfw_record_step = 1;
			pvpfw_record_count = pvpfw_record_count + 1;
			pvpfw_nextRecording = pvpfw_nextRecording + pvpfw_recordingInterval;
		};
	};
}] call BIS_fnc_addStackedEventHandler;

waitUntil{sleep 1;!pvpfw_active};

"pvpfw_record_whoPlayed" call iniDB_delete;

{
	_array = _x select 0;
	_section = _x select 1;
	{
		["pvpfw_record_whoPlayed", _section, str(_forEachIndex + 1), _x] call iniDB_write;
		sleep 0.01;
	}forEach _array;
}forEach [[pvpfw_record_bluforPlayersNames,"2CAB"],[pvpfw_record_opforPlayersNames,"5RCT"]];

for "_i" from 0 to pvpfw_record_count do{
		["pvpfw_record_blu", "pvpfw_record", format["index_%1",_i], (missionNamespace getVariable[format["pvpfw_record_blu_%1",_i],[]])] call iniDB_write;
		["pvpfw_record_red", "pvpfw_record", format["index_%1",_i], (missionNamespace getVariable[format["pvpfw_record_red_%1",_i],[]])] call iniDB_write;
		["pvpfw_record_air", "pvpfw_record", format["index_%1",_i], (missionNamespace getVariable[format["pvpfw_record_air_%1",_i],[]])] call iniDB_write;
		["pvpfw_record_car", "pvpfw_record", format["index_%1",_i], (missionNamespace getVariable[format["pvpfw_record_car_%1",_i],[]])] call iniDB_write;
		["pvpfw_record_apc", "pvpfw_record", format["index_%1",_i], (missionNamespace getVariable[format["pvpfw_record_apc_%1",_i],[]])] call iniDB_write;
		["pvpfw_record_cv", "pvpfw_record", format["index_%1",_i], (missionNamespace getVariable[format["pvpfw_record_cv_%1",_i],[]])] call iniDB_write;
		sleep 0.01;
		
		if ((_i % 100) == 0) then{
			diag_log format["#PVPFW_record: Writing recorded positions to iniDBi database. %1/%2",_i,pvpfw_record_count];
		};
};