/***********
	self destruct
***********/

_vehicle = vehicle player;

if (player == _vehicle || player != driver _vehicle || isEngineOn _vehicle) exitWith{};

pvpfw_pv_selfDestruct_vehicle = _vehicle;

if (isServer) then{
	pvpfw_pv_selfDestruct_vehicle spawn pvpfw_fnc_selfdestruct_initDestr;
}else{
	PublicVariableServer "pvpfw_pv_selfDestruct_vehicle";
};

["<t size='0.67' font='PuristaBold' shadow='2' color='#ffff8888'>" + "# CHARGES ARMED #" + "</t>",0,0.75,2,0,0,"pvpfw_selfDestruct_layer" call bis_fnc_rscLayer] spawn BIS_fnc_dynamicText;