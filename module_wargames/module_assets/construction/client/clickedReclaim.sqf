
scriptName "pvpfw_fnc_constr_chooseReclaim";

private["_cursorPos","_distance","_arrow"];

if !(player == (vehicle player) && alive player) exitWith{};

deleteVehicle (missionNamespace getVariable["pvpfw_constr_arrowObject",objNull]);
pvpfw_constr_arrowObject = "Sign_Arrow_Green_F" createvehiclelocal [0,0,0];

pvpfw_constr_action_reclaimSpecial = player addAction ["<t color='#ffff00'>Destroy untargetables nearby</t>", "module_wargames\module_assets\construction\client\remove_special.sqf"];

["pvpfw_fnc_constr_clickedReclaim","onEachFrame",{
	_cursorPos = getPosASL cursorTarget;
	_distance = (getPosASL player) distance _cursorPos;
	_distance = _distance / 2;
	if (_distance > 4) then {_distance = 4;};
	pvpfw_constr_arrowObject setPosASL [_cursorPos select 0, _cursorPos select 1, (_cursorPos select 2) + 1 + (((boundingBoxReal cursorTarget) select 1) select 2)];

	_dir = (diag_tickTime % 5) * (360 / 5);

	pvpfw_constr_arrowObject setDir _dir;

	if (!alive player || player != (vehicle player)) then{
		[] call pvpfw_fnc_constr_stopConstruction;
	};
},[]] call BIS_fnc_addStackedEventHandler;
