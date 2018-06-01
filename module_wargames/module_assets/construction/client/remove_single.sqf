private["_objToBeRemoved","_objSideValue","_enemySide","_nearEnemies"];

_objToBeRemoved = cursorTarget;
_objectSide = _objToBeRemoved getvariable ["pvpfw_constr_builtBy",sideEnemy];
_playerSide = player getVariable["pvpfw_customSide",sideUnknown];

systemChat "DEBUG: remove single object";

// exit conditions

//if (isNull _objToBeRemoved) exitWith{};
if !(_objectSide in [blufor,opfor,independent,civilian]) exitWith{};

if (_playerSide == independent) exitWith{
	deleteVehicle _objToBeRemoved;
	systemChat "DEBUG: delete as ind/civ";
};

if (_objectSide != _playerSide) exitWith{};

if ((player distance _objToBeRemoved) > 15)exitWith{
	systemChat "Too far away from object";
};

_enemySide = switch(_playerSide)do{
	case(blufor):{opfor};
	case(opfor):{blufor};
	default{sideEnemy};
};

_nearEnemies = {
	((_x getVariable["pvpfw_customSide",sideUnknown]) == _enemySide) && ((_x distance _objToBeRemoved) < 50)
}count allunits;

if (_nearEnemies == 0) then{
	_objToBeRemoved setVariable["pvpfw_constr_builtBy",sideEmpty,true];
	// TODO has to be run serverside or the script will stop on player disconnect

	[_objToBeRemoved] spawn {
		_objToBeRemoved = _this select 0;

		_bBox = boundingBoxReal _objToBeRemoved;
		_height = (abs ((_bBox select 0) select 2)) + ((_bBox select 1) select 2);

		_pos = getPosASL _objToBeRemoved;
		_z = _pos select 2;

		for "_i" from 0 to _height step 0.1 do{
			_pos set [2,_z - _i];
			_objToBeRemoved setPosASL _pos;
			uiSleep 0.2;
		};
		systemChat "DEBUG: now removing obj.";
		deleteVehicle _objToBeRemoved;
	};
};
