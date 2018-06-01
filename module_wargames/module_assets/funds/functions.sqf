pvpfw_fnc_wg_assets_getFunds = {
  _player = param [0,player,[objNull]];

  _sideString = _player getVariable["pvpfw_customSideString","ERROR"];

  _funds = missionNamespace getVariable[format["pvpfw_wg_assets_funds_%1",_sideString],-1];

  _funds
};

pvpfw_fnc_wg_assets_funds_applyCost = {
  _buyer = param [0,objNull,[objNull]];
  _cost = param [1,0,[0]];
  _item = param[2,"No Info"];

  _sideString = _buyer getVariable["pvpfw_customSideString","ERROR"];

  _fundVarString = format["pvpfw_wg_assets_funds_%1",_sideString];
  _funds = missionNamespace getVariable[_fundVarString,-1];

  _hasSufficientFunds = _funds >= _cost;

  if(_hasSufficientFunds)then{
    missionNamespace setVariable[_fundVarString,_funds - _cost];
    publicVariable _fundVarString;
  };

  _hasSufficientFunds
};

"pvpfw_pv_wg_assets_funds_applyCost" addPublicVariableEventhandler {
  _varValue = _this select 1;

  _varValue call pvpfw_fnc_wg_assets_funds_applyCost;
};
