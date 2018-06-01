
pvpfw_wg_teams_lockedInPlayers = missionNamespace getVariable["pvpfw_wg_teams_lockedInPlayers",[]];

"pvpfw_pv_wg_teams_lockInCheck" addPublicVariableEventHandler {
  _unit = _this select 0;

  _uid = getPlayerUID _unit;

  {
    if ((_x select 0) == _uid)exitWith{
      pvpfw_pv_wg_teams_assignSideToClient = (_x select 1);
      (owner _unit) publicVariableClient "pvpfw_pv_wg_teams_assignSideToClient";
    };
  }forEach pvpfw_wg_teams_lockedInPlayers;
};

"pvpfw_pv_wg_teams_playerLocksInSide" addPublicVariableEventHandler {
  _varValue = _this select 0;

  _unit = _varValue select 0;
  _side = _varValue select 1;

  _uid = getPlayerUID _unit;

  _alreadyInArray = false;

  {
    if ((_x select 0) == _uid)exitWith{
      _alreadyInArray = true;
      _x set[1,_side];
    };
  }forEach pvpfw_wg_teams_lockedInPlayers;

  if (!_alreadyInArray)then{
    pvpfw_wg_teams_lockedInPlayers pushback[_uid,_side];
  };
};
