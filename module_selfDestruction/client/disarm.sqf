/***********
	cancel self destruct
***********/

_vehicle = vehicle player;

if (player == _vehicle || player != driver _vehicle) exitWith{};

_vehicle setVariable ["pvpfw_selfdestruct_active", false, true];

["<t size='0.67' font='PuristaBold' shadow='2' color='#ff88ff88'>" + "# CHARGES DISABLED #" + "</t>",0,0.75,2,0,0,"pvpfw_selfDestruct_layer" call bis_fnc_rscLayer] spawn BIS_fnc_dynamicText;