if (diag_tickTime < ((missionNamespace getVariable ["pvpfw_constr_lastBuiltTime",0]) + 0.5)) exitWith{};
pvpfw_constr_lastBuiltTime = diag_tickTime;

_objInfo = pvpfw_wg_assets_spawnInfo select 0;

_objectClassString = _objInfo select 1;
_posASL = pvpfw_wg_assets_spawnInfo select 1;
_vectorDirAndUp = pvpfw_wg_assets_spawnInfo select 2;
_cost = _objInfo select 2;
_builtOn = pvpfw_wg_assets_spawnInfo select 3;

_factionShort = player getVariable["pvpfw_customFactionShort","blu"];

/*
if (!(pvpfw_constr_objectInfoArray select 4) && isMultiplayer) exitWith{
	["<t size='0.8' shadow='2' color='#ffffffff' font='PuristaBold'>" + "Can not build" + "</t>",0,0.25,0.25,0,0,pvpfw_constr_layer] spawn BIS_fnc_dynamicText;
};
*/

// Check our pre-build hooks
/*
_hookReturn = [_objectClassString,playerSide,_cost] call pvpfw_constr_checkPreBuildHooks; //return = [_exit, new cost]
if (_hookReturn select 0) exitWith{};
_cost = _hookReturn select 1;
["pvpfw_constr_preBuild",[]] call pvpfw_fnc_events_callEH;
*/

_funds = missionNamespace getVariable [format["pvpfw_wg_assets_funds_%1",player getVariable["pvpfw_customSideString","ERROR"]],-1];

if (_cost > _funds)exitWith{
	player sideChat "#Info: Not enough resources for this object.";
};

_text = format["-%1   (%2)",_cost,_funds - _cost];
["<t size='0.8' shadow='2' color='#ffffffff' font='PuristaBold'>" + _text + "</t>",0,0.25,0.25,0,0,pvpfw_constr_layer] spawn BIS_fnc_dynamicText;

// Send object information to the server, which will then create it globally
pvpfw_pv_constr_handleObjectOnServer = [_objectClassString,_posASL,player,_cost,_vectorDirAndUp,_builtOn];

if (isServer) then{
	pvpfw_pv_constr_handleObjectOnServer spawn pvpfw_fnc_constr_createObject;
}else{
	publicVariableServer "pvpfw_pv_constr_handleObjectOnServer";
};

// Particle effect for some visual feedback
_sizeOf = sizeOf _objectClassString;
_posVariance = (10 min _sizeOf max 1) / 2;
_particleCount = 50 max (20 * _sizeOf) min 400;

systemChat format["particles: %1",_particleCount];

_posATL = ASLtoATL _posASL;
addCamShake [2, 0.5, 50];
for "_i" from 1 to _particleCount do{
	_dropPos = [(_posATL select 0) - _posVariance  + random (_posVariance * 2), (_posATL select 1) - _posVariance + random (_posVariance * 2), random 0.25];
	drop [
		["\a3\data_f\ParticleEffects\Universal\Universal", 16, 12, 8],
		"",
		"Billboard",
		1, //time onEvent
		4, //lifetime
		_dropPos, //pos
		[-1 + random 2,-1 + random 2,-0.1 + random 0.5], //move veloc
		0, //rotation veloc
		1.3, //weight
		1.00, //volume
		0.9, //rubbing
		[1,2,2,2], //size
		[
			[0.15, 0.125, 0.1, 0.5],
			[0.6, 0.5, 0.4, 0.0]
		], //color
		[1], //animPhase
		0.1, //random dir period
		0.1, //random dir intensity
		"", //onTime
		"", //onDestruction
		""
	];
};
