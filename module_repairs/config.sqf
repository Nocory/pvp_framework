
pvpfw_repairs_repairNames = [
	["HitLFWheel","Wheel_1"],
	["HitLF2Wheel","Wheel_2"],
	["HitRFWheel","Wheel_3"],
	["HitRF2Wheel","Wheel_4"],
	["HitFuel","Fueltank"],
	["HitEngine","Engine"],
	["HitBody","Hull"],
	["asd","asd"],
	["asd","asd"],
	["asd","asd"],
	["asd","asd"],
	["asd","asd"],
	["asd","asd"],
	["asd","asd"],
	["asd","asd"],
	["asd","asd"],
	["asd","asd"],
	["asd","asd"],
	["asd","asd"],
	["asd","asd"],
	["asd","asd"],
	["asd","asd"]
];

pvpfw_repairs_getRepairName = {
	private["_configName"];
	_configName = _this select 0;
	{
		_compareConfig = _x select 0;
		if (_configName == _compareConfig) exitWith{_configName = _x select 1};
	}forEach pvpfw_repairs_repairNames;
	_configName
};