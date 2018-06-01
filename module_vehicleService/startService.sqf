
///option when close to farp trucks
private[
	"_vcl",
	"_dyntext",
	"_i",
	"_type",
	"_hasClearLineToTruck",
	"_continueFARP",
	"_layer"
];

_layer = "pvpfw_log_layer" call bis_fnc_rscLayer;

if (isNil "pvpfw_vehService_inProgress") then{
	pvpfw_vehService_inProgress = false;
};

if (pvpfw_vehService_inProgress) exitWith{};

pvpfw_vehService_inProgress = true;

_vcl = vehicle player;
_dyntext = "string";
_i = 0;
_type = typeof _vcl;
_canFARP = false;

_hasClearLineToTruck = {
	private["_obj1","_obj2","_pos1","_pos2","_intersectArray"];
	_obj1 = _this select 0;
	_obj2 = _this select 1;
	
	_pos1 = [getPosASL _obj1 select 0,getPosASL _obj1 select 1,(getPosASL _obj1 select 2) + 1.5];
	_pos2 = [getPosASL _obj2 select 0,getPosASL _obj2 select 1,(getPosASL _obj2 select 2) + 1.5];
	_intersectArray = lineIntersectsWith [_pos1, _pos2, _obj1, _obj2];
	
	if (count _intersectArray > 0) then{
		_dynText = format["Info: An object is blocking access to %1",getText (configFile >> 'CfgVehicles' >> typeOf _obj2 >> 'displayname')];
		["<t size='0.67' shadow='2' color='#ffffffff'>" + _dyntext + "</t>",0,0.6,2,0,0,_layer] spawn BIS_fnc_dynamicText;
	};
	
	(count _intersectArray == 0)
};

//check if script should be aborted
_continueFARP = {
	private["_return"];
	_return = switch (true) do{
		case (player != driver _vcl):{false};
		case (isEngineOn _vcl):{false};
		case !(alive _vcl):{false};
		default {true};
	};
	_return
};

// Check if a FARP truck is accessible
{
	if ((typeOf _x) in pvpfw_vehService_FARPSources && [vehicle player,_x] call _hasClearLineToTruck) exitWith{
		_canFARP = true;
	};
}forEach nearestObjects [vehicle player, ["Car"], 25];

// Exit if we cant farp
if !(player == (driver _vcl) && _canFARP) exitWith{
	["<t size='0.67' shadow='2' color='#ffffffff'>" + "No suitable Farp-Truck" + "</t>",0,0.6,2,0,0,_layer] spawn BIS_fnc_dynamicText;
	pvpfw_vehService_inProgress = false;
};

["<t size='0.67' shadow='2' color='#ffffffff'>" + "Beginning vehicle services" + "</t>",0,0.6,2,0,0,_layer] spawn BIS_fnc_dynamicText;
sleep 2;

// BEGIN FARP
{
	for "_i" from 1 to 10 do{
		if !([] call _continueFARP) exitWith{};
		_dyntext = format["%1 progress %2/100",_x select 0,_i * 10];
		["<t size='0.67' shadow='2' color='#ffffffff'>" + _dyntext + "</t>",0,0.6,2,0,0,_layer] spawn BIS_fnc_dynamicText;
		sleep 1;
	};

	if !([] call _continueFARP) exitWith{};
	_vcl call (_x select 1);
	
	sleep 1;
}forEach [["Repair",{_this setDamage 0}],["Refuel",{_this setFuel 1}],["Reammo",{_this setVehicleAmmo 1}]];

// After vehicle is fully serviced
if ([] call _continueFARP) then{
	_dyntext = "# Vehicle has been fully serviced #";
	["<t size='0.67' shadow='2' color='#ffffffff'>" + _dyntext + "</t>",0,0.6,2,0,0,_layer] spawn BIS_fnc_dynamicText;
}else{
	["<t size='0.67' shadow='2' color='#ffffffff'>" + "## FARP ABORTED ##" + "</t>",0,0.6,2,0,0,_layer] spawn BIS_fnc_dynamicText;
};

////////////
//ALL DONE//
////////////
pvpfw_vehService_inProgress = false;