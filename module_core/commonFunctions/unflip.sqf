_vehicle = vehicle player;

if (player != _vehicle && player == driver _vehicle) then{
	_pos = getPos _vehicle;
	if ((speed _vehicle < 2) && ((_pos select 2) < 2) && !(isEngineOn _vehicle))then{
		_vehicle setPos _pos;
	}else{
		systemChat "* Stop moving and turn off the engine to unflip the vehicle *";
	};
}else{
	systemChat "* You are not the driver of a vehicle *";
};