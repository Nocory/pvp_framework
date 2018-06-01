pvpfw_wg_assets_vehicles_handlePurchase = {
	_type = _this select 0;
	_cost = _this select 1;
	_buyer = _this select 2;

	_buyerSide = _buyer getVariable["pvpfw_customSide",civilian];
	_sideString = _buyer getVariable["pvpfw_customSideString","ERROR"];

  // check for available spawner
  _availableSpawner = objNull;

  _i = 1;
  while{!isNil ("pvpfw_wg_vehicleSpawner_" + _sideString + "_" + str(_i))}do{
    _spawner = missionNamespace getVariable["pvpfw_wg_vehicleSpawner_" + _sideString + "_" + str(_i),objNull];
    _nearestObjects = nearestObjects [_spawner, ["Car","Tank","Air"], 10];
    {
      if (!alive _x) then{
        deleteVehicle _x;
      };
    }forEach _nearestObjects;
    _nearestObjects = _nearestObjects - [objNull];

    if((count _nearestObjects) == 0)exitWith{
      _availableSpawner = _spawner;
    };

    systemChat str(_i);

    _i = _i + 1;
  };

  systemChat format["nullSpawner: %1",isNull _availableSpawner];
  systemChat format["avail: %1",_availableSpawner];

  // buy and deduct funds
  if (!isNull _availableSpawner)then{

		_success = [_buyer,_cost] call pvpfw_fnc_wg_assets_funds_applyCost;

		if (!_success) exitWith{};

    _vehicle = createVehicle [_this select 0, [random 500,random 500,4500 + (random 500)], [], 0, "CAN_COLLIDE"];
    _vehicle setDir (direction _availableSpawner);
    _vehicle setPos (getPosATL _availableSpawner);

		_vehicle disableTIEquipment true;

		_vehicle setVariable["pvpfw_customSide",_buyerSide,true];
		_vehicle setVariable["pvpfw_needsMarker",true,true];
  };

	// TODO send a message back to buyer
};

"pvpfw_pv_wg_assets_vehicles_purchaseInfo" addPublicVariableEventHandler {
	_varValue = _this select 1;

  _varValue call pvpfw_wg_assets_vehicles_handlePurchase;
};
