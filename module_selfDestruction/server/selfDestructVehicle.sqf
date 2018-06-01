/***********
	self destruct
***********/

_vehicle = _this;

if (_vehicle getVariable ["pvpfw_selfdestruct_active",false]) exitWith{}; //avoid double destruction

_vehicle setVariable ["pvpfw_selfdestruct_active", true, true]; // set destruciton state
_vehicle setVariable ["pvpfw_selfdestruct_fuel", fuel _vehicle, true];

_destrTime = diag_tickTime + 30;

// from 1 to 0.25

waitUntil{
	_timeLeft = _destrTime - diag_tickTime;
	_pause = 0.75 * (_timeLeft / 30);
	_pause = _pause + 0.25;
	systemChat str(_timeLeft / 30);
	sleep (_pause max 0.1);

	playSound3D ["A3\Sounds_F\missions\invalidCoords.ogg",_vehicle,false,getPosASL _vehicle,0.67,1,50];

	if (fuel _vehicle > 0)then{_vehicle setFuel 0;};
	diag_tickTime >= _destrTime || !(_vehicle getVariable["pvpfw_selfdestruct_active",false])
};

if !(_vehicle getVariable["pvpfw_selfdestruct_active",false]) exitWith{
	_vehicle setFuel (_vehicle getVariable ["pvpfw_selfdestruct_fuel", 1]);
};

if (_vehicle distance (markerPos "respawn_west") < 200 || _vehicle distance (markerPos "respawn_east") < 200) then{
	_vehicle setPosASL [-1000 + random(100),-1000 + random(100),5000 + random(100)];
	sleep 1;
	_vehicle setDamage 1;
}else{
	_vehicle setDamage 1;
	//deleteVehicle _vehicle;
};
