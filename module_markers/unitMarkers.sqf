

// *** HOT-RELOAD CLEANUP BEGIN
player removeEventHandler ["Respawn", missionNamespace getVariable["pvpfw_markers_playerRespawnEH",-1]];
["pvpfw_markers_checkLoop"] call pvpfw_fnc_terminate;
["pvpfw_markers_updateLoop","onEachFrame"] call BIS_fnc_removeStackedEventHandler;

{deleteMarkerLocal (_x select 1);}forEach ((missionNamespace getVariable["pvpfw_markers_allMarkedInf",[]]) + (missionNamespace getVariable["pvpfw_markers_allMarkedVeh",[]]));

{
	_x setVariable ["pvpfw_marker","",false];
}forEach (allUnits + vehicles);

pvpfw_markers_allMarkedInf = [];
pvpfw_markers_allMarkedVeh = [];

pvpfw_markers_infCounter = 0;
pvpfw_markers_vehCounter = 0;
// *** HOT-RELOAD CLEANUP END

// set all AIs ready to be marked if in the editor
if (!isMultiplayer)then{
	{
		if(_x != player)then{
			_x setVariable ["pvpfw_customSide",side _x];
		};
	}forEach allunits; // TODO allPlayers here and below for multiplayer
};

pvpfw_player_customSide = player getVariable["pvpfw_customSide",civilian];

pvpfw_fnc_markers_createInfantryMarker = {
	_unit = _this;

	//if (player == _unit) exitWith{[] call compile preprocessFileLineNumbers "module_markers\unitMarkers_new.sqf"};

	//if (_unit getVariable["pvpfw_customSide",civilian] != _playerSide && _playerSide != independent) exitWith{};

	_unitLetter = (toUpper(_unit getVariable["pvpfw_unitName","Zulu"])) select [0,1];
	_tag = switch(_unit getVariable["pvpfw_rank",""])do{
		case("OpCom"):{"OpCom"};
		case("Admin"):{"*"};
		case("officer"):{_unitLetter + "|CO"};
		default{_unitLetter};
	};

	_trait = switch(_unit getVariable["pvpfw_trait",""])do{
		case("medic"):{"-med"};
		case("repair"):{"-rep"};
		case("construction"):{"-con"};
		default{""};
	};

	_fullName = (_tag + _trait + "|" + (_unit getVariable["pvpfw_player_rawName",name _unit]));
	_unit setVariable["pvpfw_player_fullName",_fullName,false];

	if !(pvpfw_player_customSide in [_unit getVariable["pvpfw_customSide",civilian],independent]) exitWith{};

	_newMarker = _unit getVariable["pvpfw_marker",""];
	if(_newMarker == "")then{
		_newMarker = createMarkerLocal [format["pvpfw_marker_inf_%1",pvpfw_markers_infCounter], [0, 0, 0]];
		_unit setVariable["pvpfw_marker",_newMarker,false];
		pvpfw_markers_infCounter = pvpfw_markers_infCounter + 1;
		pvpfw_markers_allMarkedInf pushback [_unit,_newMarker];
	};

	_newMarker setMarkerTextLocal _fullName;
	_newMarker setMarkerTypeLocal "mil_triangle_noshadow";
	_newMarker setMarkerAlphaLocal 0.6;
	_newMarker setMarkerSizeLocal [0.55,0.85];
	_newMarker setMarkerPosLocal (getPosASL _unit);
	_newMarker setMarkerDirLocal (direction _unit);

	if (pvpfw_player_customSide != independent)then{
		_newMarker setMarkerColorLocal (_unit getVariable["pvpfw_markerColor","ColorBlack"]);
	}else{
		switch(_unit getVariable["pvpfw_customSide",civilian])do{
			case(blufor):{_newMarker setMarkerColorLocal "ColorBlufor";};
			case(opfor):{_newMarker setMarkerColorLocal "ColorOpfor";};
			default{_newMarker setMarkerColorLocal "ColorBlack";};
		};
	};
};

if (!isNil "pvpfw_markers_PVEHSet")then{
	"pvpfw_PV_markers_createMarker" addPublicVariableEventHandler {
		(_this select 1) call pvpfw_fnc_markers_createInfantryMarker;
	};
	pvpfw_markers_PVEHSet = true;
};

pvpfw_markers_playerRespawnEH = player addEventHandler ["Respawn", {
	_unit = _this select 0;

	_unit setvariable ["pvpfw_markers_fullName",pvpfw_markers_fullPlayerName,true];
	_unit spawn {
		sleep random(2);
		pvpfw_PV_markers_createMarker = _this;
		publicVariable "pvpfw_PV_markers_createMarker";
		_this call pvpfw_fnc_markers_createInfantryMarker;
	};
}];

[] spawn {
	sleep 0.5;
	{
		sleep 0.01;
		_x call pvpfw_fnc_markers_createInfantryMarker;
	}forEach allUnits;
};

// Marker updates

pvpfw_markers_infIndex = 0;
pvpfw_markers_vehIndex = 0;

pvpfw_markers_infIndexesToRemove = [];
pvpfw_markers_vehIndexesToRemove = [];

pvpfw_markers_allMarkedInfSnapshot = [];
pvpfw_markers_allMarkedInfSnapshotSize = count pvpfw_markers_allMarkedInfSnapshot;

pvpfw_markers_vehArraySnapshot = [];
pvpfw_markers_vehArraySnapshotSize = count pvpfw_markers_vehArraySnapshot;

["pvpfw_markers_update", "onEachFrame", {
	private["_count","_array","_unit","_marker"];

	//////////////////////
	// Infantry Markers //
	//////////////////////
	if(pvpfw_markers_infIndex >= pvpfw_markers_allMarkedInfSnapshotSize)then{
		reverse pvpfw_markers_infIndexesToRemove;
		{
			pvpfw_markers_allMarkedInf deleteAt _x;
		}forEach pvpfw_markers_infIndexesToRemove;
		pvpfw_markers_infIndexesToRemove resize 0;

		pvpfw_markers_infIndex = 0;
		pvpfw_markers_allMarkedInfSnapshot = +pvpfw_markers_allMarkedInf;
		pvpfw_markers_allMarkedInfSnapshotSize = count pvpfw_markers_allMarkedInfSnapshot;

		if (pvpfw_markers_allMarkedInfSnapshotSize == 0) exitWith{};
	};

	_array = pvpfw_markers_allMarkedInfSnapshot select pvpfw_markers_infIndex;
	_unit = _array select 0;
	_marker = _array select 1;

	if (alive _unit) then{
		if (_unit == (vehicle _unit)) then{
			_marker setMarkerPosLocal (getPosASL _unit);
			_marker setMarkerDirLocal (direction _unit);
		}else{
			_marker setMarkerPosLocal [-50000,-50000];
		};
	}else{
		pvpfw_markers_infIndexesToRemove pushBack pvpfw_markers_infIndex;
		[_marker,"mil_warning_noshadow",[0.5,0.5],30,0] call pvpfw_fnc_markers_createDeadUnitMarker;
	};
	pvpfw_markers_infIndex = pvpfw_markers_infIndex + 1;

	/////////////////////
	// Vehicle Markers //
	/////////////////////
	if(pvpfw_markers_vehIndex >= pvpfw_markers_vehArraySnapshotSize)then{
		reverse pvpfw_markers_vehIndexesToRemove;
		{
			pvpfw_markers_vehicleArray deleteAt _x;
		}forEach pvpfw_markers_vehIndexesToRemove;
		pvpfw_markers_vehIndexesToRemove resize 0;

		pvpfw_markers_vehIndex = 0;
		pvpfw_markers_vehArraySnapshot = +pvpfw_markers_vehicleArray;
		pvpfw_markers_vehArraySnapshotSize = count pvpfw_markers_vehArraySnapshot;

		if (pvpfw_markers_vehArraySnapshotSize == 0) exitWith{};
	};

	_array = pvpfw_markers_vehArraySnapshot select pvpfw_markers_vehIndex;
	_unit = _array select 0;
	_marker = _array select 1;

	if (alive _unit) then{
		_marker setMarkerPosLocal (getPosASL _unit);
		_marker setMarkerDirLocal (direction _unit);
		_marker setMarkerTextLocal format["(%1)%2",count crew _unit,(_array select 2)];
	}else{
		pvpfw_markers_vehIndexesToRemove pushBack pvpfw_markers_vehIndex;
		deleteMarkerLocal _marker;
		[(getPosASL _unit),"mil_warning_noshadow",[0.5,0.5],(_array select 2),30,0] call pvpfw_fnc_markers_createDeadUnitMarker;
	};
	pvpfw_markers_vehIndex = pvpfw_markers_vehIndex + 1;
},[]] call BIS_fnc_addStackedEventHandler;
