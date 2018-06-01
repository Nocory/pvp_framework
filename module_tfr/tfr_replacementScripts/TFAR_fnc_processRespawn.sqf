[] spawn {
	waitUntil {!(isNull player)};	
	
	TF_respawnedAt = time;
	if (alive player) then{
		_receivesLR = if (!isMultiplayer || pvpfw_playerIsAdmin || (typeOf player) in pvpfw_tfr_longRangeRadioUnitTypes) then[{false},{false}];
		
		if (_receivesLR) then{
			if (backpack player == "B_Parachute") exitWith {};
			if ([(backpack player), "tf_hasLRradio", 0] call TFAR_fnc_getConfigProperty == 1) exitWith {};
			
			private ["_items", "_backPack", "_newItems"];
			_items = backpackItems player;
			_backPack = unitBackpack player;
			player action ["putbag", player];
			sleep 3;
			player addBackpack ((call TFAR_fnc_getDefaultRadioClasses) select 0);			
			_newItems = [];
			{
				if (player canAddItemToBackpack _x) then
				{
					player addItemToBackpack _x;
				}
				else
				{
					_newItems set [count _newItems, _x];
				};
			} count _items;
			
			clearItemCargoGlobal _backPack;
			clearMagazineCargoGlobal _backPack;
			clearWeaponCargoGlobal _backPack;
			{
				if (isClass (configFile >> "CfgMagazines" >> _x)) then
				{
					_backPack addMagazineCargoGlobal [_x, 1];
				}
				else
				{
					_backPack addItemCargoGlobal [_x, 1];
					_backPack addWeaponCargoGlobal [_x, 1];
				};
			} count _newItems;
		};
		true call TFAR_fnc_requestRadios;						
	};
};