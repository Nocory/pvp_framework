if (!hasInterface)exitWith{};

if (["pvpfw_infAware", "onEachFrame"] call pvpfw_fnc_cse_inStacked)then{
	["pvpfw_infAware", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
};

{ctrlDelete _x}forEach (missionNamespace getVariable["pvpfw_infAware_allControls",[]]);

pvpfw_infAware_allControls = [];

for "_i" from 0 to 9 do{
  pvpfw_infAware_allControls pushBack (findDisplay 46 ctrlCreate ["RscStructuredText", 3770 + _i]);
};

{
  _x ctrlSetPosition [-2,-2,safeZoneH * 0.025,safeZoneH * 0.025];
  _x ctrlSetBackgroundColor [1,1,1,0.5];
  _x ctrlCommit 0;
}forEach pvpfw_infAware_allControls;

//if (true) exitWith{};

[] spawn{
	sleep 0.1;
	["pvpfw_infAware", "onEachFrame", {
    //systemChat str(diag_tickTime);
		disableSerialization;

    _nearEntities = player nearEntities ["Man", 10];
    _nearEntities = _nearEntities - [player];
    _nearEntities resize ((count _nearEntities) min 10);

    {
      _ctrl = pvpfw_infAware_allControls select _forEachIndex;

      _relDir = player getRelDir _x;
      _dist = player distance _x;

      _playerPos = getPosASL player;
      _entPos = getPosASL _x;

      _relPos = player getRelPos [_dist, _relDir];

      //_relPosX = (_relPos select 0) - ;

      systemChat str(_relDir);

      _ctrlPos = [
        [0.5 - ((safeZoneH * 0.025) / 2),0.5 - ((safeZoneH * 0.025) / 2)],
        (_dist / 10),
        _relDir
      ] call BIS_fnc_relPos;

      systemChat str(_ctrlPos);
      _ctrlPos set[1,(safeZoneH) - (_ctrlPos select 1) + safeZoneX];
      systemChat str(_ctrlPos);

      /*
      _ctrlPos = [
        (((_relPos select 0) / (_playerPos select 0)) - 1)
        + (0.5 - ((safeZoneH * 0.05) / 2)),
        0
        + (0.5 - ((safeZoneH * 0.05) / 2))
      ];
      */

      _ctrl ctrlSetPosition _ctrlPos;
      _ctrl ctrlCommit 0;
    }forEach _nearEntities;

    systemChat str(count _nearEntities);

    for "_i" from (count _nearEntities) to 9 do{
      _ctrl = pvpfw_infAware_allControls select _i;
      _ctrl ctrlSetPosition [-2, -2];
      _ctrl ctrlCommit 0;
      //systemChat str(_i);
    };
	}] call BIS_fnc_addStackedEventHandler;
};
