

[] call compile preprocessFileLineNumbers "module_training\config.sqf"

pvpfw_training_enabled = true;

pvpfw_fnc_training_enable = {
	pvpfw_training_enabled = true;
};

pvpfw_fnc_training_disable = {
	pvpfw_training_enabled = false;
};


//[{pvpfw_playerReadyToMove},"Training-mode enabled","Training features are available in the commo-rose",true,{false}] call pvpfw_fnc_hints_registerHint;

[[],{
	scriptName "pvpfw_training_unlimitedAmmo";

	private["_ammo"];

	_ammo = [];
	if (typeOf player in ["B_soldier_LAT_F","O_Soldier_LAT_F"]) then{_ammo pushBack "NLAW_F";};
	if (count _ammo == 0) exitWith{};

	while{true}do{
		{
			if !(_x in (magazines player)) then{
				player addMagazine _x;
			};
			sleep 0.1;
		}forEach _ammo;
		sleep 2;
	};
},"pvpfw_training_unlimitedAmmo"] call pvpfw_fnc_spawnOnce;
