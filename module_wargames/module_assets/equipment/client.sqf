pvpfw_wg_assets_equipment_respawnEquipment = compile preprocessFileLineNumbers "module_wargames\module_assets\equipment\respawnEquipment.sqf";

[player] spawn pvpfw_wg_assets_equipment_respawnEquipment;

player removeEventHandler ["respawn", missionNamespace getVariable["pvpfw_wg_assets_equipment_clientRespawnEH",-1]];
pvpfw_wg_assets_equipment_clientRespawnEH = player addEventHandler ["respawn",{
	[player] spawn pvpfw_wg_assets_equipment_respawnEquipment;
}];

pvpfw_wg_assets_equipment_getValue = {
	_equipment = param[0,getUnitLoadout player];
	_value = param[1,0];

	if (typeName _equipment == "ARRAY")then{
		{
			_value = [_x,_value] call pvpfw_wg_assets_equipment_getValue;
		}forEach _equipment;
	};

	if(typeName _equipment == "STRING")then{
		_sideCostArray = missionNamespace getVariable[format["pvpfw_wg_assets_equipment_arsenalArray%1",player getVariable["pvpfw_customSideString","civ"]],[]];
		{
			{
				if (_equipment == (_x select 0)) exitWith{
					_value = _value + (_x select 1);
				};
			}forEach _x;
		}forEach _sideCostArray;
	};

	_value
};

pvpfw_wg_assets_equipment_addTrait = {
	_items = items player;
	if ("Medikit" in _items)then{player setUnitTrait ["Medic",true];};
	if ("ToolKit" in _items)then{player setUnitTrait ["Engineer",true];};
};

pvpfw_wg_assets_equipment_openArsenal = {
	_arsenalCrate = missionNamespace getVariable[format["pvpfw_wg_assets_arsenalCrate%1",player getVariable["pvpfw_customSideString","CIV"]],objNull];
	["Open",[nil,_arsenalCrate,player]] spawn BIS_fnc_arsenal;
};

[[],{
  while{true}do{
    _isArsenalOpen = false;
    waitUntil{sleep 0.881;_isArsenalOpen = !(isnull (uinamespace getvariable ["BIS_fnc_arsenal_cam",objnull]));_isArsenalOpen};

		_startLoadout = getUnitLoadout player;

    _startValue = [] call pvpfw_wg_assets_equipment_getValue;

    _layer = "pvpfw_wg_assets_equipment_test" call bis_fnc_rscLayer;

    _cost = 0;

    while{_isArsenalOpen}do{

      _value = [] call pvpfw_wg_assets_equipment_getValue;
      _cost = _value - _startValue;
      if (_cost < 0) then {_cost = _cost / 2};

      _text = "<t size='0.6' shadow='2' color='#ffffff'>" +
  		"Equipment Value:  " + str(_value) + "<br/>" +
  		"<br/>" +
  		"Army Funds:  " + str([] call pvpfw_fnc_wg_assets_getFunds) + "<br/>" +
  		"New Cost:  " + str(_cost) + "</t>";

  		[_text,0,safeZoneY + (SafeZoneH * 0.70),1,0,0,_layer] spawn BIS_fnc_dynamicText;

      sleep 0.2;
      _isArsenalOpen = !(isnull (uinamespace getvariable ["BIS_fnc_arsenal_cam",objnull]));
    };

		_value = [] call pvpfw_wg_assets_equipment_getValue;
		_cost = _value - _startValue;
		if (_cost < 0) then {_cost = _cost / 2};

		if (_cost > ([] call pvpfw_fnc_wg_assets_getFunds) && _cost > 0) then{
			["<t size='1.0' font='PuristaBold' shadow='2' color='#FFFF6347'>" + "Insufficient Funds..." + "</t>",0,safeZoneY + (SafeZoneH * 0.50),3,0,0,"pvpfw_wg_assets_equip_insuf"] spawn BIS_fnc_dynamicText;
			player setUnitLoadout _startLoadout;
		}else{
			[] call pvpfw_wg_assets_equipment_addTrait;

	    pvpfw_pv_wg_assets_funds_applyCost = [player,_cost,"equipment"];
	    if (isServer) then{
	      pvpfw_pv_wg_assets_funds_applyCost call pvpfw_fnc_wg_assets_funds_applyCost;
	    }else{
	      publicVariableServer "pvpfw_pv_wg_assets_funds_applyCost";
	    };
		};
  };
},"pvpfw_wg_assets_equipment_test"] call pvpfw_fnc_spawnOnce;
