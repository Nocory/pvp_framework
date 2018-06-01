pvpfw_misc_detectSuddenVelocityChange = {
	private["_lastVel","_thisVel","_mag"];
	
	_thisVel = velocity player;
	_lastVel = player getVariable ["pvpfw_misc_lastVel",_thisVel];
	player setVariable ["pvpfw_misc_lastVel",_thisVel];
	
	_mag = ([_thisVel,_lastVel] call BIS_fnc_vectorDiff) call BIS_fnc_magnitude;
	
	if (_mag > 4) then{
		systemChat str(_mag);
		if (_mag > 8) then{
			player setDamage ((_mag - 8) / 5);
		};
	};
};

pvpfw_misc_ejectWithChute = {
	private["_pos","_velocity","_chute"];
	
	_vehVelocity = velocity (vehicle player);
	
	player allowDamage false;
	player action ["Eject", vehicle player];
	
	_initTime = diag_tickTime;
	waitUntil{player == vehicle player || (diag_tickTime - _initTime) > 0.2};
	sleep 0.1;
	player allowDamage true;
	
	sleep 2;
	
	if (player != vehicle player) exitWith{};
	
	_velocity = velocity player;
	
	player allowDamage false;
	
	_chute = createVehicle ["NonSteerable_Parachute_F", [random 500,random 500,1000 + random(500)], [], 0, "NONE"];
	_chute allowDamage false;
	
	player disableCollisionWith _chute;
	
	_chute setDir direction player;
	_chute setPosASL (getPosASL player);
	_chute setVelocity _velocity;
	player moveInDriver _chute;
	
	_chute setVariable["pvpfw_customFaction","CIV_F",true];
	
	player allowDamage true;
	
	[] spawn{
		player setVariable ["pvpfw_misc_lastVel",velocity player];
		while{alive player && (vehicle player) isKindOf "Air"}do{
			[] call pvpfw_misc_detectSuddenVelocityChange;
			sleep 0.1;
		};
	};
	
	waitUntil{sleep 0.1;vehicle player != _chute};
	sleep 2;
	if (alive _chute) then {deleteVehicle _chute;};
	
	player allowDamage true;
};

private["_action","_vehicle"];

while{true}do{
	waitUntil{sleep 1;(vehicle player) isKindOf "Air"};
	
	_action = -1;
	
	_vehicle = vehicle player;
	if (player != driver _vehicle) then{
		_action = player addAction ["<t color='#ffff00'>Parachute</t>", {[] call pvpfw_misc_ejectWithChute},[],10,true,true,"","((position player) select 2) > 25"];
	};

	waitUntil{sleep 0.1;(vehicle player) != _vehicle};
	
	if (_action != -1) then{
		player removeAction _action;
	};
};
