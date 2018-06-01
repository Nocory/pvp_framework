private["_objToBeRemoved","_objSideValue","_enemySide","_nearEnemies"];

_playerSide = player getVariable["pvpfw_customSide",sideUnknown];

{
	_objToBeRemoved = _x;
	_objSideValue = _objToBeRemoved getvariable ["pvpfw_constr_builtBy",civilian];

	if (_objSideValue == _playerSide && typeOf _objToBeRemoved in pvpfw_constr_catUntargetable) then{

		_enemySide = switch(_playerSide)do{
			case(blufor):{opfor};
			case(opfor):{blufor};
			default{civilian};
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

				for "_i" from 0 to _height step 0.05 do{
					_pos set [2,_z - _i];
					_objToBeRemoved setPosASL _pos;
					uiSleep 0.1;
				};
				systemChat "DEBUG: now removing obj.";
				deleteVehicle _objToBeRemoved;
			};
		};
	};
}forEach ((position player) nearObjects 8);
