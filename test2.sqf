/*
[1] call compile preProcessFileLineNumbers "test2.sqf"
*/

 private ["_object","_rotations","_aroundX","_aroundY","_aroundZ","_dirX","_dirY","_dirZ","_upX","_upY","_upZ","_dir","_up","_dirXTemp", "_upXTemp"]; _object = _this select 0; _rotations = _this select 1; _aroundX = _rotations select 0; _aroundY = _rotations select 1; _aroundZ = (360 - (_rotations select 2)) - 360; _dirX = 0; _dirY = 1; _dirZ = 0; _upX = 0; _upY = 0; _upZ = 1; if (_aroundX != 0) then { _dirY = cos _aroundX; _dirZ = sin _aroundX; _upY = -sin _aroundX; _upZ = cos _aroundX; }; if (_aroundY != 0) then { _dirX = _dirZ * sin _aroundY; _dirZ = _dirZ * cos _aroundY; _upX = _upZ * sin _aroundY; _upZ = _upZ * cos _aroundY; }; if (_aroundZ != 0) then { _dirXTemp = _dirX; _dirX = (_dirXTemp* cos _aroundZ) - (_dirY * sin _aroundZ); _dirY = (_dirY * cos _aroundZ) + (_dirXTemp * sin _aroundZ); _upXTemp = _upX; _upX = (_upXTemp * cos _aroundZ) - (_upY * sin _aroundZ); _upY = (_upY * cos _aroundZ) + (_upXTemp * sin _aroundZ); }; _dir = [_dirX,_dirY,_dirZ]; _up = [_upX,_upY,_upZ]; [_dir,_up]

/*

//myTable = "extDB" callExtension "0:custom:loadTable:'playerTable'";
//myTable = "extDB" callExtension "0:custom:loadRow:'playerTable':'_SP_PLAYER_'";

call compile preProcessFileLineNumbers "\inidbi\init.sqf"; //initialize the iniDB addon

if (isNil "pvpfw_extDBInit")then{
	"extDB" callExtension "9:ADD:MISC:misc";
	sleep 0.1;
	"extDB" callExtension "9:DATABASE:cnr";
	sleep 0.1;
	pvpfw_extDBInit = true;
};

"extDB" callExtension "9:ADD:DB_CUSTOM_V2:custom:Example";

_arg = [_this,0,1,[1]] call BIS_fnc_param;

_getHPDamage = {
	_unit = _this;
	_hitPoints = [];
	{
		_hitPoints pushback [configName _x,_unit getHitPointDamage (configName _x)];
	}forEach ("true" configClasses (configFile >> "CfgVehicles" >> (typeOf _unit) >> "HitPoints"));
	_hitPoints
};

_savePlayerInfo = {
	_unit = _this;

	_infoString = format["'%1','%2','%3','%4','%5','%6','%7','%8','%9','%10','%11','%12','%13','%14','%15','%16','%17','%18','%19','%20','%21','%22','%23','%24','%25','%26','%27','%28','%29','%30'",
		// UID
		getPlayerUID _unit, // 1
		
		// player info
		getPosATL _unit, // 2
		direction _unit, // 3
		
		animationState _unit, // 4
		
		// inventory info
		primaryWeapon _unit, // 5
		primaryWeaponMagazine _unit, // 6
		primaryWeaponItems _unit, // 7
		
		secondaryWeapon _unit, // 8
		secondaryWeaponMagazine _unit, // 9
		secondaryWeaponItems _unit, // 10
		
		handgunWeapon _unit, // 11
		handgunMagazine _unit, // 12
		handgunItems _unit, // 13
		
		assignedItems _unit, // 14
		
		goggles _unit, // 15
		
		uniform _unit, // 16
		uniformItems _unit, // 17
		
		vest _unit, // 18
		vestItems _unit, // 19
		
		headgear _unit, // 20
		
		backPack _unit, // 21
		backpackItems _unit, // 22
		
		// vehicle info
		(vehicle _unit) getVariable ["pvpfw_pers_vehicleID","NO_ID"], // vehicle // 23
		assignedVehicleRole _unit, // role in vehicle // 24
		if (_unit == vehicle _unit)then{-1}else{(vehicle _unit) getCargoIndex _unit}, // cargo position // 25
		
		// damage info
		damage _unit, // 26
		_unit call _getHPDamage, // 27
		
		// misc
		_unit getVariable["pvpfw_playerFaction","NO_FACTION"], // 28
		_unit getVariable["pvpfw_funds",0], // 29
		(call compile ("extDB" callExtension "0:misc:TIME")) select 1 // 30
	];

	pvpfw_pers_debug = "extDB" callExtension format["0:custom:savePlayerInfo:%1",_infoString];
	
	systemChat format["player - %1",_forEachIndex];
};

if (_arg > 0)then{
	{
		if (isPlayer _x)then{
			_x call _savePlayerInfo;
			sleep 0.1;
		}else{
			sleep 0.01;
		};
	}forEach allUnits;
	
	{
		_vehicleID = _x getVariable ["pvpfw_pers_vehicleID","NO_ID"];
		
		if (_vehicleID == "NO_ID") then{
			_vehicleID = format["%1_%2_%3_%4_%5",pvpfw_common_natoAlphabet call BIS_fnc_selectRandom,pvpfw_common_natoAlphabet call BIS_fnc_selectRandom,floor random 11, floor random 11, floor random 11];
			_x setVariable["pvpfw_pers_vehicleID",_vehicleID,true];
		};
		
		myInfoString = format["'%1','%2','%3','%4','%5','%6','%7','%8','%9','%10','%11','%12'",
			_vehicleID,
			
			typeOf _x,
			
			(getPosWorld _x) call pvpfw_fnc_core_posToString,
			[vectorDir _x,vectorUp _x],
			
			getWeaponCargo _x,
			getMagazineCargo _x,
			getItemCargo _x,
			getBackpackCargo _x,
			
			fuel _x,
			damage _x,
			_x call _getHPDamage,
			
			(call compile ("extDB" callExtension "0:misc:TIME")) select 1
		];
		
		pvpfw_pers_debug = "extDB" callExtension format["0:custom:saveVehicleInfo:%1",myInfoString];
		
		systemChat format["vcl - %1",_forEachIndex];
		
		sleep 0.1;
	}forEach vehicles;
	
	if (true)exitWith{};
	
	{
		_infoArray = [
			typeOf _x,
			
			(getPosWorld _x) call pvpfw_fnc_core_posToString,
			[vectorDir _x,vectorUp _x],
			
			_x getVariable ["pvpfw_constr_builtBy","NO_FACTION"]
		];
		
		_time = (call compile ("extDB" callExtension "0:misc:TIME")) select 1;
		pvpfw_pers_debug2 = "extDB" callExtension format["0:custom:saveInfo_new:%1:%2:%3:%4",'objectTable',_vehicleID,_infoArray,_time];
		
		systemChat format["obj - %1",_forEachIndex];
		
		sleep 0.1;
	}forEach (missionNamespace getVariable["pvpfw_missionObjects",[]]);
	
	systemChat "DONE";
}else{
	// restore vehicles
	myTable = "extDB" callExtension "0:custom:loadTable:'vehicleTable'";

	my_tableArray = toArray myTable;
	{
		if (_x == 34)then{
			my_tableArray set[_forEachIndex,39];
		};
	}forEach my_tableArray;
	my_newTableString = toString my_tableArray;

	_infoArray = (((call compile my_newTableString) select 1) select 1);
	myInfoArray = _infoArray;

	{
		deleteVehicle _x;
	}forEach vehicles;

	{
		_id = _x select 0;
		_type = _x select 1;
		_pos = call compile (_x select 2);
		_vectorDirUp = _x select 3;
		_wepCargo = _x select 4;
		_magCargo = _x select 5;
		_itemCargo = _x select 6;
		_backpackCargo = _x select 7;
		_fuel = _x select 8;
		_dam = _x select 9;
		_HPDam = _x select 10;
		_time = _x select 11;
		
		_vehicle = createVehicle [_type, [random -1000,random -1000,2000 + random 2000], [], 0, "CAN_COLLIDE"];
		
		_vehicle setVectorDirAndUp _vectorDirUp;
		_vehicle setPosWorld _pos;
		
		_vehicle setVariable ["pvpfw_pers_vehicleID",_id,true];
		
		_vehicle disableTIEquipment true;
		
		clearMagazineCargoGlobal _vehicle;
		clearWeaponCargoGlobal _vehicle;
		clearItemCargoGlobal _vehicle;
		clearBackpackCargoGlobal _vehicle;
		
		{_vehicle addWeaponCargoGlobal [_x, (_wepCargo select 1) select _forEachIndex]}foreach (_wepCargo select 0);
		{_vehicle addMagazineCargoGlobal [_x, (_magCargo select 1) select _forEachIndex]}foreach (_magCargo select 0);
		{_vehicle addItemCargoGlobal [_x, (_itemCargo select 1) select _forEachIndex]}foreach (_itemCargo select 0);
		{_vehicle addBackpackCargoGlobal [_x, (_backpackCargo select 1) select _forEachIndex]}foreach (_backpackCargo select 0);
		
		_vehicle setFuel _fuel;
		_vehicle setDamage _dam;
		{
			_vehicle setHitPointDamage [_x select 0, _x select 1];
		}forEach _HPDam;
	}forEach _infoArray;
	//restore player
	
	myTable = "extDB" callExtension "0:custom:loadRow:'playerTable':'_SP_PLAYER_'";
	
	my_tableArray = toArray myTable;
	{
		if (_x == 34)then{
			my_tableArray set[_forEachIndex,39];
		};
	}forEach my_tableArray;
	my_newTableString = toString my_tableArray;

	_infoArray = (((call compile my_newTableString) select 1) select 1) select 0;
	myInfoArray = _infoArray;
	
	_id = _infoArray select 0;
	
	_pos = _infoArray select 1;
	_dir = _infoArray select 2;
	
	_anim = _infoArray select 3;
	
	_primWep = _infoArray select 4;
	_primMag = _infoArray select 5;
	_primWepItems = _infoArray select 6;
	
	_secWep = _infoArray select 7;
	_secMag = _infoArray select 8;
	_secWepItems = _infoArray select 9;
	
	_hgWep = _infoArray select 10;
	_hgMag = _infoArray select 11;
	_hgWepItems = _infoArray select 12;
	
	_assignedItems = _infoArray select 13;
	
	_goggles = _infoArray select 14;
	
	_uniform = _infoArray select 15;
	_uniformItems = _infoArray select 16;
	
	_vest = _infoArray select 17;
	_vestItems = _infoArray select 18;
	
	_headgear = _infoArray select 19;
	
	_backPack = _infoArray select 20;
	_backPackItems = _infoArray select 21;
	
	_vclID = _infoArray select 22;
	_assignedVehicleRole = _infoArray select 23;
	_vehicleCargoIndex = _infoArray select 24;
	
	_dam = _infoArray select 25;
	_HPDam = _infoArray select 26;
	
	_faction = _infoArray select 27;
	_funds = _infoArray select 28;
	_time = _infoArray select 29;
	
	// remove all current equipment
	removeAllWeapons player;
	removeAllAssignedItems player;
	
	removeVest player;
	removeUniform player;
	removeHeadgear player;
	
	removeBackpack player;
	
	sleep 0.2;
	
	// add saved equipment
	player forceAddUniform _uniform;
	player addvest _vest;
	player addBackpack _backPack;
	player addHeadgear _headgear;
	
	sleep 0.5;
	
	{player linkItem _x}forEach _assignedItems;
	player addGoggles _goggles;
	
	// weapons
	
	{if (count _x != 0)then{player addMagazine (_x select 0)}}forEach[_primMag,_secMag,_hgMag];
	
	if (_primWep != "")then{player addWeapon _primWep;};
	if (_secWep != "")then{player addWeapon _secWep;};
	if (_hgWep != "")then{player addWeapon _hgWep;};
	
	{if (_x != "") then{player addPrimaryWeaponItem _x}}forEach _primWepItems;
	{if (_x != "") then{player addSecondaryWeaponItem _x}}forEach _secWepItems;
	{if (_x != "") then{player addHandgunItem _x}}forEach _hgWepItems;
	
	// items
	{player addItemToUniform _x;}forEach _uniformItems;
	{player addItemToVest _x;}forEach _vestItems;
	{player addItemToBackpack _x;}forEach _backPackItems;
	
	sleep 0.5;
	
	if (_vclID != "NO_ID")then{
		{
			if (_x getVariable ["pvpfw_pers_vehicleID","NO_ID"] == _vclID) then{
				systemChat str(_assignedVehicleRole);
				systemChat str(_x);
				switch(_assignedVehicleRole select 0)do{
					case("driver"):{
						player moveInDriver _x;
					};
					case("Turret"):{
						player moveInTurret [_x,(_assignedVehicleRole select 1)];
						systemChat "isTurret";
					};
					case("cargo"):{
						player moveInCargo [_x, _vehicleCargoIndex];
					};
				};
			};
		}forEach vehicles;
	}else{
		player setPosASL _pos;
		player setDir _dir;
		
		player switchMove _anim;
	};
	
	// damage
	player setDamage _dam;
	
	{
		player setHitPointDamage [_x select 0, _x select 1];
	}forEach _HPDam;
};