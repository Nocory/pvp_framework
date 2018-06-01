#include "config.sqf"

if ((typeOf player) in ["B_Helipilot_F","O_helipilot_F"]) then{
	[{player == (driver vehicle player) && (vehicle player) isKindOf "Helicopter_Base_H"},"Pilot features available","Air-lift objects by pressing (ctrl + win-key)",true,{false}] call pvpfw_fnc_hints_registerHint;
	//[{player == (driver vehicle player) && (vehicle player) isKindOf "Helicopter_Base_H"},"Pilot features available","Press (win-key) by itself to see more info",true,{false}] call pvpfw_fnc_hints_registerHint;
};

/**************************
	Monitor
**************************/
if (isServer) then{
	pvpfw_log_activeLifters = [];
	pvpfw_log_newActiveLifters = [];
	[[],{
		scriptName "pvpfw_log_monitor";
		while{true}do{
			[pvpfw_log_activeLifters, pvpfw_log_newActiveLifters] call BIS_fnc_arrayPushStack;
			pvpfw_log_newActiveLifters resize 0;
			sleep 0.05;
			{
				_liftedVehicle = _x getVariable ["pvpfw_log_liftedvehicle",objNull];
				if (!isNull _liftedVehicle || !alive _x) then{
					if (((getPosATL _liftedVehicle) select 2) < 0) then{
					//if (isTouchingGround _liftedVehicle) then{
						//_x call pvpfw_log_detachFromChopper;
						_ownerOfAttached = owner _liftedVehicle;
						
						//detach on the machine where the attached vehicle is local, so we can set the velocity properly
						if (local _liftedVehicle) then{
							_x call pvpfw_log_detachFromChopper;
							//setAccTime 0.25;
						}else{
							_ownerOfAttached publicVariableClient "pvpfw_log_PV_detachFromChopper"; 
						};
					};
				}else{
					pvpfw_log_activeLifters set [_forEachIndex,objNull];
				};
				sleep 0.05;
			}forEach pvpfw_log_activeLifters;
			
			pvpfw_log_activeLifters = pvpfw_log_activeLifters - [objNull];
			sleep 0.057;
		};
	},"pvpfw_log_monitor"] call pvpfw_fnc_spawn;
};

/**************************
	Attach
**************************/
pvpfw_log_attachToChopper = {
	_vehicle = _this select 0;
	_chopper = _this select 1;
	
	_vehicle attachTo [_chopper,[0,0,-7.5]];
	_chopper setVariable ["pvpfw_log_liftedvehicle",_vehicle,true];
	pvpfw_log_newActiveLifters pushBack _chopper;
};

"pvpfw_log_PV_attachToChopper" addPublicVariableEventhandler{
	_varName = _this select 0;
	_varValue = _this select 1;
	
	_varValue call pvpfw_log_attachToChopper;
};

/**************************
	Detach
**************************/
pvpfw_log_detachFromChopper = {
	_attachedObject = (_this getVariable["pvpfw_log_liftedvehicle",objNull]);
	
	//diag_log format["###DEBUG: detaching %1",_attachedObject];
	
	_velocity = velocity _attachedObject;
	
	detach _attachedObject;
	
	if (((getPosATL _attachedObject) select 2) < 0) then{
		_attachedObject setPosATL [((getPosATL _attachedObject) select 0),((getPosATL _attachedObject) select 1),0.1];
	};
	
	//_attachedObject setVelocity (velocity _this);
	_attachedObject setVelocity [(_velocity select 0) * 0.9,(_velocity select 1) * 0.9,(_velocity select 2)];
	
	_this setVariable ["pvpfw_log_liftedvehicle",objNull,true];
	
	[_attachedObject] spawn{
		_vehicle = _this select 0;
		
		sleep 4;
		
		if (((getPosATL _vehicle) select 2) < 20) exitWith{};
		
		_chute = createVehicle ["I_Parachute_02_F", [0,0,0], [], 0, "CAN_COLLIDE"];
		_chute disableCollisionWith _vehicle;
		_chute setPosATL (getPosATL _vehicle);
		_chute setDir (direction _vehicle);
		//_chute setVectorDirAndUp [vectorDir _vehicle,vectorUp _vehicle];
		_chute setVelocity (velocity _vehicle);
		//sleep 0.01;
		_vehicle attachTo [_chute,[0,0.5,-3]];
		_chute setCenterOfMass [[0,0,-3],0];
		
		waitUntil{((getPosATL _vehicle) select 2) <= 0.6 || isNull _chute};
		detach _vehicle;
		if (!isNull _chute) then{
			deleteVehicle _chute
		};
	};
};

"pvpfw_log_PV_detachFromChopper" addPublicVariableEventhandler{
	_varName = _this select 0;
	_varValue = _this select 1;
	
	_attachedObject = (_varValue getVariable["pvpfw_log_liftedvehicle",objNull]);
	
	_ownerOfAttached = owner _attachedObject;
	
	//detach on the machine where the attached vehicle is local, so we can set the velocity properly
	if (isServer) then{
		if (local _attachedObject) then{
			_varValue call pvpfw_log_detachFromChopper;
		}else{
			_ownerOfAttached publicVariableClient "pvpfw_log_PV_detachFromChopper"; 
		};
	}else{
		_varValue call pvpfw_log_detachFromChopper;
	};
};

//Client part below
if (isDedicated) exitWith{};

pvpfw_log_pilotpressedLiftKey = {
	private["_vehicle","_lifter","_liftedVehicle","_displayName"];
	
	_lifter = vehicle player;
	
	if (((getPosATL _lifter) select 2) < 10) exitWith{};
	
	_liftedVehicle = _lifter getVariable["pvpfw_log_liftedvehicle",objNull];
	if (!isNull _liftedVehicle) exitWith{
		// _liftedVehicle is not null, so we are better dropping whatever is attached to the chopper instead of picking up something else.
		addCamShake [2, 0.5, 10];
		
		pvpfw_log_PV_detachFromChopper = _lifter;
		
		if (isServer) then{
			_handle = pvpfw_log_PV_detachFromChopper call pvpfw_log_detachFromChopper;
		}else{
			publicVariableServer "pvpfw_log_PV_detachFromChopper";
		};
	};
	
	_vehicle = nearestObjects [player, pvpfw_log_canBeLifted, 20];
	
	if (count _vehicle > 0) then{
		_vehicle = _vehicle select 0;
		{
			if (_vehicle isKindOf _x) exitWith{
				_vehicle = objNull;
			};
		}forEach pvpfw_log_excludeFromLifting;
	}else{
		_vehicle = objNull;
	};
	
	if (isNull _vehicle) exitWith{}; //no closest vehicle, or closest vehicle is not of the correct type
	if (!alive _vehicle) exitWith{}; //cant lift a wreck
	if !(_vehicle getVariable["pvpfw_log_liftable",true]) exitWith{}; //cant lift vehicles that were set to be non-liftable
	if (({alive _x} count (crew _vehicle)) > 0) exitWith{}; //closest vehicle must be empty
	
	// Alright we can lift the vehicle
	
	addCamShake [2, 0.5, 10];
	_displayName = getText (configFile >> 'CfgVehicles' >> typeOf _vehicle >> 'displayname');
	
	systemChat format["= %1 was attached to your chopper. =",_displayName];
	pvpfw_log_PV_attachToChopper = [_vehicle,_lifter];
	if (isServer) then{
		pvpfw_log_PV_attachToChopper call pvpfw_log_attachToChopper;
	}else{
		publicVariableServer "pvpfw_log_PV_attachToChopper";
	};
};

[] spawn{
	["ArmA Wargames", "Airlift Vehicle", {
		if (player != vehicle player && {(typeOf (vehicle player)) in pvpfw_log_lifters} && {player == driver (vehicle player)}) then{
			[] call pvpfw_log_pilotpressedLiftKey;
		};
	}, [219,false,true,false],false,"keydown"] call CBA_fnc_registerKeybind;
};
