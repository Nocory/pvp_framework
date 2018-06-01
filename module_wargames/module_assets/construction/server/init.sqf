// Server

pvpfw_constr_newBuiltObjects = missionNamespace getVariable["pvpfw_constr_newBuiltObjects",[]];
pvpfw_constr_builtObjects = missionNamespace getVariable["pvpfw_constr_builtObjects",[]];; //all objects that have been constructed by players. Server will use this array to monitor the objects state
pvpfw_constr_allObjects = missionNamespace getVariable["pvpfw_constr_allObjects",[]];;

"pvpfw_pv_constr_changeOwnership" addPublicVariableEventhandler {
	_varValue = _this select 1;

	_varValue spawn{
		{
			if (_x isKindOf "LandVehicle") then{
				_x spawn{
					private["_AIHelper"];

					_AIHelper = (group pvpfw_attendant_blu) createUnit ["VirtualMan_F", [random 2000,random 2000,6000], [], 0, "CAN_COLLIDE"];

					_AIHelper disableAI "MOVE";
					_AIHelper disableAI "FSM";

					sleep 0.2;

					_AIHelper moveInDriver _this;

					sleep 0.25;

					waitUntil{
						deleteVehicle _AIHelper;
						sleep 0.1;
						isNull _AIHelper
					};
				};
				sleep 0.05;
			};
		}forEach _this;
	};
};

pvpfw_fnc_constr_createObject = {
	_objectClassString = _this select 0;
	_newPos = _this select 1;
	_builder = _this select 2;
	_cost = _this select 3;
	_vectorDirUp = _this select 4;
	_builtOn = _this select 5;

	// Adjust the supplies and send them back ot the clients
	_sufficientFunds = [_builder,_cost] call pvpfw_fnc_wg_assets_funds_applyCost;

	if (!_sufficientFunds) exitWith{};

	// Create the object initially
	_newObject = createVehicle [_objectClassString, [random -1000,random -1000,2000 + random 2000], [], 0, "CAN_COLLIDE"];

	_newObject setVectorDirAndUp _vectorDirUp;
	_newObject setPosASL _newPos;
	
	// Set the important variables on the object
	[_newObject,"pvpfw_constr_builtBy", _builder getVariable["pvpfw_customSide",sideEmpty], true] call pvpfw_fnc_core_setVariable;
	[_newObject,"pvpfw_constr_objCost", _cost, false] call pvpfw_fnc_core_setVariable;

	// Add it to the array of new objects. The server will take objects out of this and add them to the normal array it loops through.
	//pvpfw_constr_newBuiltObjects set [count pvpfw_constr_newBuiltObjects, [_newObject,_cost,_side]];

	if (!isNull _builtOn)then{
		_objectsBuiltOnTop = _builtOn getVariable["pvpfw_constr_objectsBuiltOnTop",[]];
		if (count _objectsBuiltOnTop == 0)then{
			_builtOn addEventhandler["killed",{
				[_this select 0] spawn{
					_building = _this select 0;
					{
						deleteVehicle _x;
						sleep 0.1;
					}forEach (_building getVariable["pvpfw_constr_objectsBuiltOnTop",[]]);
				};

			}];
		};
		_builtOn setVariable["pvpfw_constr_objectsBuiltOnTop",_objectsBuiltOnTop + [_newObject],false];
	};

	// Post build hooks
	//[_newObject,_side] call pvpfw_constr_checkPostBuildHooks;
	["pvpfw_constr_postBuild",[_newObject]] call pvpfw_fnc_events_callEH;

	pvpfw_constr_allObjects pushback _newObject;
};

"pvpfw_pv_constr_handleObjectOnServer" addPublicVariableEventHandler {
	(_this select 1) spawn pvpfw_fnc_constr_createObject;
};
