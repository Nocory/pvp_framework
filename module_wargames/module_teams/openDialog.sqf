disableSerialization;

_dialog = createdialog "pvpfw_wg_teams_dialog";

{
	_x ctrlSetFade 1;
	_x ctrlCommit 0;
}forEach (allControls (findDisplay 19202));

{
	_x ctrlSetFade 0;
	_x ctrlCommit 2;
}forEach (allControls (findDisplay 19202));

((findDisplay 19202) displayCtrl 1600) ctrlAddEventHandler ["ButtonClick", {
	[blufor] call pvpfw_fnc_wg_teams_setSide;
}];

((findDisplay 19202) displayCtrl 1601) ctrlAddEventHandler ["ButtonClick", {
	[opfor] call pvpfw_fnc_wg_teams_setSide;
}];

((findDisplay 19202) displayCtrl 1607) ctrlAddEventHandler ["ButtonClick", {
	["OpCom"] call pvpfw_fnc_wg_teams_setUnitDesignation;
}];

((findDisplay 19202) displayCtrl 1603) ctrlAddEventHandler ["ButtonClick", {
	["Alpha"] call pvpfw_fnc_wg_teams_setUnitDesignation;
}];

((findDisplay 19202) displayCtrl 1604) ctrlAddEventHandler ["ButtonClick", {
	["Bravo"] call pvpfw_fnc_wg_teams_setUnitDesignation;
}];

((findDisplay 19202) displayCtrl 1605) ctrlAddEventHandler ["ButtonClick", {
	["Charlie"] call pvpfw_fnc_wg_teams_setUnitDesignation;
}];

((findDisplay 19202) displayCtrl 1606) ctrlAddEventHandler ["ButtonClick", {
	["Delta"] call pvpfw_fnc_wg_teams_setUnitDesignation;
}];

((findDisplay 19202) displayCtrl 1609) ctrlAddEventHandler ["ButtonClick", {
	if !(player getVariable ["pvpfw_rank",""] in ["OpCom","Admin"]) exitWith{};
	{
		_unit = _x;
		if (_x getVariable ["pvpfw_player_fullName",""] == pvpfw_wg_teams_selectedName)exitWith{
			if(_x getVariable ["pvpfw_rank",""] == "")then{
				_x setVariable ["pvpfw_rank","officer",true];
			}else{
				_x setVariable ["pvpfw_rank","",true];
				_x setVariable["pvpfw_isOpCom",false,true];
			};

			pvpfw_PV_markers_createMarker = _x;
			publicVariable "pvpfw_PV_markers_createMarker";
			_x call pvpfw_fnc_markers_createInfantryMarker;
		};
	}forEach allUnits;
}];

pvpfw_wg_teams_selectedName = "NONE";
{
	_x ctrlAddEventHandler ["LBSelChanged",{
		missionNamespace setVariable["pvpfw_wg_teams_selectedName",(_this select 0) lbText (_this select 1)];
	}];
}forEach [((findDisplay 19202) displayCtrl 1501),((findDisplay 19202) displayCtrl 1502),((findDisplay 19202) displayCtrl 1503),((findDisplay 19202) displayCtrl 1504)];

((findDisplay 19202) displayCtrl 1602) ctrlAddEventHandler ["ButtonClick", {
	_password = ctrlText ((findDisplay 19202) displayCtrl 1400);
	// TODO passwords must be loaded from an iniDBi database and not hardcoded into the pbo
	// TODO make opcom auth functional again
	if(_password == "opcompw")then{
		player setVariable["pvpfw_isOpCom",true,true];
		player setVariable["pvpfw_rank","OpCom",true];
	};
	if(_password == "adminpw")then{
		player setVariable["pvpfw_rank","Admin",true];
	};

	pvpfw_PV_markers_createMarker = player;
	publicVariable "pvpfw_PV_markers_createMarker";
	player call pvpfw_fnc_markers_createInfantryMarker;
}];

_unassigned = [];

_opComBlufor = [];
_opComOpfor = [];

_playersBlufor = [];
_playersOpfor = [];

while{!isNull (findDisplay 19202) && pvpfw_wg_mf_status > 1}do{
	_unassigned resize 0;
	_opComBlufor resize 0;
	_opComOpfor resize 0;
	_playersBlufor resize 0;
	_playersOpfor resize 0;

	{
		_name = _x getVariable["pvpfw_player_fullName","??" + (name _x)];

		switch(_x getVariable["pvpfw_customSide",civilian])do{
			case(blufor):{if(_x getVariable["pvpfw_isOpCom",false])then[{_opComBlufor pushBack _name;},{_playersBlufor pushBack _name;}];};
			case(opfor):{if(_x getVariable["pvpfw_isOpCom",false])then[{_opComOpfor pushBack _name;},{_playersOpfor pushBack _name;}];};
			default{_unassigned pushBack _name;};
		};
	}forEach allUnits;

	((findDisplay 19202) displayCtrl 1600) ctrlSetText format["Join Blufor (%1)",(count _opComBlufor) + (count _playersBlufor)];
	((findDisplay 19202) displayCtrl 1601) ctrlSetText format["Join Opfor (%1)",(count _opComOpfor) + (count _playersOpfor)];

	_ctrl = ((findDisplay 19202) displayCtrl 1500);
	lbClear _ctrl;
	{
		_ctrl lbAdd _x;
	}forEach _unassigned;

	_ctrl = ((findDisplay 19202) displayCtrl 1501);
	lbClear _ctrl;
	{
		_ctrl lbAdd _x;
	}forEach _playersBlufor;

	_ctrl = ((findDisplay 19202) displayCtrl 1502);
	lbClear _ctrl;
	{
		_ctrl lbAdd _x;
	}forEach _playersOpfor;


	_ctrl = ((findDisplay 19202) displayCtrl 1503);
	lbClear _ctrl;
	{
		_ctrl lbAdd _x;
	}forEach _opComBlufor;

	_ctrl = ((findDisplay 19202) displayCtrl 1504);
	lbClear _ctrl;
	{
		_ctrl lbAdd _x;
	}forEach _opComOpfor;


	sleep 0.219;
};
