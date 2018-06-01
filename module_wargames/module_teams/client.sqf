// TODO register menu entry and set vars on army/unit choice

pvpfw_fnc_wg_teams_openDialog = compile preprocessFileLineNumbers "module_wargames\module_teams\openDialog.sqf";

pvpfw_fnc_wg_teams_setSide = {
  _chosenSide = param[0,civilian,[civilian]];
  _informServer = param[1,true];

  _sideString = switch(_chosenSide)do{
    case(blufor):{"blu"};
    case(opfor):{"red"};
    case(independent):{"ind"};
    default{"civ"};
  };

  pvpfw_playerCustomSide = _chosenSide;
  player setVariable["pvpfw_customSide",_chosenSide,true];
  player setVariable["pvpfw_customSideString",_sideString,true];

  pvpfw_PV_markers_createMarker = player;
  publicVariable "pvpfw_PV_markers_createMarker";
  player call pvpfw_fnc_markers_createInfantryMarker;

  if(_informServer)then{
    pvpfw_pv_wg_teams_playerLocksInSide = [player,_chosenSide];
    publicVariableServer "pvpfw_pv_wg_teams_playerLocksInSide";
  };

  [] call compile preprocessFileLineNumbers "module_markers\init.sqf";

  player setPos (markerPos format["pvpfw_respawn_%1",_chosenSide]);
};

pvpfw_fnc_wg_teams_setUnitDesignation = {
  _choice = param[0,"Zulu",[""]];

  player setVariable["pvpfw_unitName",_choice,true];

  _color = switch(_choice)do{
    case("Alpha"):{"ColorBlack"};
    case("Bravo"):{"ColorBlufor"};
    case("Charlie"):{"ColorIndependent"};
    case("Delta"):{"ColorCivilian"};
    default{"ColorBlack"}
  };

  player setVariable["pvpfw_markerColor",_color,true];

  pvpfw_PV_markers_createMarker = player;
  publicVariable "pvpfw_PV_markers_createMarker";
  player call pvpfw_fnc_markers_createInfantryMarker;
};

// TODO needs logging and make sure there is no publicvariable feedback loop here

"pvpfw_pv_wg_teams_assignSideToClient" addPublicVariableEventHandler {
  _varValue = _this select 0;

  [_varValue,false] call pvpfw_fnc_wg_teams_setSide;
};

[] spawn{
  waitUntil{!isNull player};

  pvpfw_pv_wg_teams_lockInCheck = player;
  publicVariableServer "pvpfw_pv_wg_teams_lockInCheck";
};
