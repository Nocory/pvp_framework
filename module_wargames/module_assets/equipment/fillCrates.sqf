{
  clearWeaponCargoGlobal _x;
  clearMagazineCargoGlobal _x;
  clearItemCargoGlobal _x;
  clearBackpackCargoGlobal _x;
}forEach [pvpfw_wg_assets_baseCrateBlu,pvpfw_wg_assets_baseCrateRed];

_allMagazines = [];

{
  [pvpfw_wg_assets_arsenalCrateBlu,_x select 0, true, false] call BIS_fnc_addVirtualWeaponCargo;

  _weaponMags = getArray (configFile >> "CfgWeapons" >> (_x select 0) >> "magazines");
  {
    _allMagazines pushBackUnique _x;
  }forEach _weaponMags;
}forEach (pvpfw_wg_assets_equipment_arsenalArrayBlu select 0);

diag_log "allMags";
diag_log _allMagazines;

{
  pvpfw_wg_assets_baseCrateBlu addMagazineCargoGlobal [_x, 1000];
}forEach _allMagazines;

{
  if (typeName _x == "STRING") then {_x = [_x,0]};
  [pvpfw_wg_assets_arsenalCrateBlu,_x select 0, true, false] call BIS_fnc_addVirtualMagazineCargo;
}forEach ((pvpfw_wg_assets_equipment_arsenalArrayBlu select 1) + _allMagazines);

{
  [pvpfw_wg_assets_arsenalCrateBlu,_x select 0, true, false] call BIS_fnc_addVirtualBackpackCargo;
}forEach (pvpfw_wg_assets_equipment_arsenalArrayBlu select 2);

for "_i" from 3 to 8 do{
  {
    [pvpfw_wg_assets_arsenalCrateBlu,_x select 0, true, false] call BIS_fnc_addVirtualItemCargo;
  }forEach (pvpfw_wg_assets_equipment_arsenalArrayBlu select _i);
};
