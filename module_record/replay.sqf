/*
if (!isNil "record_handle")then{terminate record_handle;};
record_handle = [] execVm "module_record\replay.sqf";
*/

["pvpfw_replay", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;

{
	deleteVehicle _x;
}forEach (allunits - [player]);

pvpfw_drawInfClusters = compile preProcessFileLineNumbers "module_record\drawClusters.sqf";

pvpfw_record_readCountBegin = 1;
pvpfw_record_readCount = pvpfw_record_readCountBegin;
pvpfw_record_preCalcEnd = 3590;

//_handle = [] spawn compile preProcessFileLineNumbers "module_record\preCalc.sqf";
//waitUntil{scriptDone _handle};

{
	for "_i" from 0 to (_x select 0) do{
		_marker = createMarkerLocal [format["%1_%2",(_x select 1),_i], [0, 0, 0]];
		_marker setMarkerColorLocal (_x select 2);
		_marker setMarkerTypeLocal (_x select 3);
		_marker setMarkerAlphaLocal (_x select 4);
		_marker setMarkerSizeLocal (_x select 5);
		_marker setMarkerTextLocal (_x select 6);
	};
}forEach[
	[30,"pvpfw_record_inf_blu","ColorBlue","mil_dot_noshadow",0.7,[0.50,0.50],""],
	[30,"pvpfw_record_inf_red","ColorRed","mil_dot_noshadow",0.7,[0.50,0.50],""],
	[10,"pvpfw_record_car_blu","ColorBlue","n_motor_inf",1,[0.67,0.67],"Car"],
	[10,"pvpfw_record_car_red","ColorRed","n_motor_inf",1,[0.67,0.67],"Car"],
	[2,"pvpfw_record_apc_blu","ColorBlue","n_mech_inf",1,[0.67,0.67],"APC"],
	[2,"pvpfw_record_apc_red","ColorRed","n_mech_inf",1,[0.67,0.67],"APC"],
	[1,"pvpfw_record_cv_blu","ColorBlue","n_armor",1,[0.67,0.67],"CV"],
	[1,"pvpfw_record_cv_red","ColorRed","n_armor",1,[0.67,0.67],"CV"],
	[2,"pvpfw_record_air_blu","ColorBlue","n_air",1,[0.67,0.67],"Air"],
	[2,"pvpfw_record_air_red","ColorRed","n_air",1,[0.67,0.67],"Air"]
];

{
	for "_i" from 0 to (_x select 0) do{
		_string = format["%1_%2",(_x select 1),_i];
		deleteMarker _string;
		_marker = createMarkerLocal [_string, [0, 0, 0]];
		_marker setMarkerColorLocal (_x select 2);
		_marker setMarkerShapeLocal (_x select 3);
		_marker setMarkerBrushLocal (_x select 4);
		_marker setMarkerAlphaLocal (_x select 5);
		_marker setMarkerSizeLocal (_x select 6);
	};
}forEach[
	[30,"pvpfw_record_inf_bluArea","ColorBlufor","ellipse","Solid",0.1,[50,50]],
	[30,"pvpfw_record_inf_redArea","ColorOpfor","ellipse","Solid",0.1,[50,50]]
];

systemChat "Created All Replay Markers";

pvpfw_replayCounter = 0;
["pvpfw_replay", "onEachFrame", {
	if (diag_frameNo % 2 == 1)then{
		// INF
		{
			_string = _x select 0;
			_to = _x select 1;
			
			_count = 0;
			{
				_marker = format["%1_%2",_string,_forEachIndex];
				_marker setMarkerPosLocal _x;
				_marker = format["%1Area_%2",_string,_forEachIndex];
				_marker setMarkerPosLocal _x;
				_count = _count + 1;
			}forEach (missionNamespace getVariable[format["%1_%2",_string,pvpfw_replayCounter],[]]);
			
			for "_i" from _count to _to do{
				_marker = format["%1_%2",_string,_i];
				_marker setMarkerPosLocal [0,0];
				_marker = format["%1Area_%2",_string,_i];
				_marker setMarkerPosLocal [0,0];
			};
		}forEach[
			["pvpfw_record_inf_blu",30],
			["pvpfw_record_inf_red",30]
		];
	};
	
	if (diag_frameNo % 2 == 1)then{
		// VEHICLES
		{
			_string = _x select 0;
			_to = _x select 1;
			_count = 0;
			{
				_marker = format["%1_%2",_string,_forEachIndex];
				_marker setMarkerPosLocal (_x select 0);
				_marker setMarkerDirLocal (_x select 1);
				_count = _count + 1;
			}forEach (missionNamespace getVariable[format["%1_%2",_string,pvpfw_replayCounter],[]]);
			
			for "_i" from _count to _to do{
				_marker = format["%1_%2",_string,_i];
				_marker setMarkerPosLocal [0,0];
			};
		}forEach[
			["pvpfw_record_car_blu",10],
			["pvpfw_record_car_red",10],
			["pvpfw_record_apc_blu",2],
			["pvpfw_record_apc_red",2],
			["pvpfw_record_cv_blu",1],
			["pvpfw_record_cv_red",1],
			["pvpfw_record_air_blu",2],
			["pvpfw_record_air_red",2]
		];
		
		systemChat str(pvpfw_replayCounter);
		pvpfw_replayCounter = pvpfw_replayCounter + 1;
		
		if (pvpfw_replayCounter >= pvpfw_record_preCalcEnd)then{
			["pvpfw_replay", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
		};
	};
	

}] call BIS_fnc_addStackedEventHandler;