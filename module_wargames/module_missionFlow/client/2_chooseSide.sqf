while{pvpfw_wg_mf_status > 1}do{
  if (isNull (findDisplay 19202))then{
    [[],pvpfw_fnc_wg_teams_openDialog,"pvpfw_fnc_wg_teams_openDialog"] call pvpfw_fnc_spawnOnce;
  };
  sleep 4;
};
