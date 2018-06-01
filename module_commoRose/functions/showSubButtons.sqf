disableSerialization;

[] call pvpfw_fnc_commoRose_clearSubEntries;

_sourceControl = param [0,-1];
_actionArray = param [1,[]];

_ctrlPos = ctrlPosition _sourceControl;

_leftOrRight = if ((_ctrlPos select 0) > 0.5) then[{1},{-1}];

_h = safezoneH * 0.025;
_w = _h * 5;

_yStep = _h * 1.5;
_dirStep = 10;

_startY = 0.5 - (((count _actionArray) - 1) / 2) * _yStep;
_dirOffset = (((count _actionArray) - 1) / 2) * _dirStep;

{
	_control = (uiNamespace getVariable['pvpfw_core_dialog',controlNull]) ctrlCreate ["RscButton", -1];
	pvpfw_commoRose_allSubControls pushback _control;

	_control ctrlSetText (_x select 0);
	_control buttonSetAction (str parsetext (format["[] call %1",(_x select 1)]));

	_control ctrlSetPosition _ctrlPos;
	_control ctrlSetFade 1;
	_control ctrlCommit 0;
	_control buttonSetAction (str parsetext (format["[] call %1",(_x select 1)]));

	_relPos = [[0.5,0.5],safeZoneW * 0.21,(90 * _leftOrRight) + _dirOffset - (_forEachIndex * _dirStep)] call BIS_fnc_relPos;
	_xPos = _relPos select 0;
	_yPos = _startY + (_forEachIndex*_yStep);

	_control ctrlSetPosition [_xPos - (_w/2),_yPos - (_h/2),_w,_h];
	_control ctrlSetFade 0;
	_control ctrlCommit 0.15;
}forEach _actionArray;
