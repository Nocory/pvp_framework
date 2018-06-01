_activePage = param [0,"Page_Default"];
_centerCursor = param [1,false];
if (_centerCursor) then{
	setMousePosition [0.5, 0.5];
};

disableSerialization;

if (isNull (uiNamespace getVariable['pvpfw_core_dialog',controlNull])) then{
	_dialog = createdialog "pvpfw_core_dialog";
};

[] call pvpfw_fnc_commoRose_clearSubEntries;
[] call pvpfw_fnc_commoRose_resetRose;

pvpfw_commoRose_allControls = [];
pvpfw_commoRose_allSubControls = [];

_h = safezoneH * 0.025;
_w = _h * 5;

//////////////
/// Center ///
//////////////

_centerButtons = [];
{
	if([] call (_x select 4))then{
		_centerButtons pushBack _forEachIndex;
	};
}forEach (missionNameSpace getVariable[format["pvpfw_commoRose_%1_contextual",_activePage],[]]);

_yStep = _h * 1.5;
_startY = 0.5 - (((count _centerButtons) - 1) / 2) * _yStep;

{
	_yPos = _startY + (_forEachIndex*_yStep);

	_control = (uiNamespace getVariable['pvpfw_core_dialog',controlNull]) ctrlCreate ["RscButton", -1];
	_control ctrlSetPosition [0.5 - ((_w*0.6)/2),_yPos - (_h/2),_w*0.6,_h];
	_control ctrlSetText (((missionNameSpace getVariable[format["pvpfw_commoRose_%1_contextual",_activePage],[]]) select _x) select 1);
	_control ctrlCommit 0;
	_control buttonSetAction format["['%1_contextual',%2,%3] call pvpfw_fnc_commoRose_buttonClicked;",_activePage,_x,count pvpfw_commoRose_allControls];
	pvpfw_commoRose_allControls pushback _control;
}forEach _centerButtons;

////////////
/// ROSE ///
////////////

_leftButtons = [];
_rightButtons = [];
{
	if([] call (_x select 4))then{
		if (((count _leftButtons) + (count _rightButtons)) % 2 == 0)then{
			_leftButtons pushBack _forEachIndex;
		}else{
			_rightButtons pushBack _forEachIndex;
		};
	};
}forEach (missionNameSpace getVariable[format["pvpfw_commoRose_%1",_activePage],[]]);

_createButton = {
	_pageEntryIndex = _this select 0;
	_control = (uiNamespace getVariable['pvpfw_core_dialog',controlNull]) ctrlCreate ["RscButton", -1];
	_control ctrlSetPosition [_xPos - (_w/2),_yPos - (_h/2),_w,_h];
	_control ctrlSetText (((missionNameSpace getVariable[format["pvpfw_commoRose_%1",_activePage],[]]) select _pageEntryIndex) select 1);
	_control ctrlCommit 0;
	_control buttonSetAction format["['%1',%2,%3] call pvpfw_fnc_commoRose_buttonClicked;",_activePage,_pageEntryIndex,count pvpfw_commoRose_allControls];
	pvpfw_commoRose_allControls pushback _control;
	_control
};

_yStep = _h * 1.5;
_dirStep = 20;

_startY = 0.5 - (((count _leftButtons) - 1) / 2) * _yStep;
_dirOffset = (((count _leftButtons) - 1) / 2) * _dirStep;
{
	_relPos = [[0.5,0.5],safeZoneW * 0.1,-90 + _dirOffset - (_forEachIndex * _dirStep)] call BIS_fnc_relPos;
	_xPos = _relPos select 0;
	_yPos = _startY + (_forEachIndex*_yStep);
	[_x] call _createButton;
}forEach _leftButtons;

_startY = 0.5 - (((count _rightButtons) - 1) / 2) * _yStep;
_dirOffset = (((count _rightButtons) - 1) / 2) * _dirStep;
{
	_relPos = [[0.5,0.5],safeZoneW * 0.1,90 + _dirOffset - (_forEachIndex * _dirStep)] call BIS_fnc_relPos;
	_xPos = _relPos select 0;
	_yPos = _startY + (_forEachIndex*_yStep);
	[_x] call _createButton;
}forEach _rightButtons;


//////////////////
// PAGE BUTTONS //
//////////////////
_counter = 0;
_accesiblePages = {[] call (_x select 1)} count pvpfw_commoRose_initializedPages;
_center = [0.5 - _w / 2,0.5 + _h * 10 - _h / 2];
_startX = (_center select 0) - ((_accesiblePages - 1) / 2) * _w * 1.1;
_startY = (_center select 1);
{
	if ([] call (_x select 1))then{
		_identifier = _x param [0,"Page_Default"];
		_text = _x param [2,_identifier];
		_color = _x param [3,"#ffffff"];

		//_control = (findDisplay 19505) ctrlCreate ["RscButton", -1];
		_control = (uiNamespace getVariable['pvpfw_core_dialog',controlNull]) ctrlCreate ["RscButton", -1];
		pvpfw_commoRose_allControls pushback _control;

		_control ctrlSetPosition [_startX + _counter * _w * 1.1,_startY,_w,_h];
		_control ctrlSetText _text;
		//_control ctrlSetTextColor _color;
		_control buttonSetAction format["['%1'] call pvpfw_fnc_commoRose_open;",_identifier];

		// REVIEW how can the button color be changed???
		//_control ctrlSetBackgroundColor [1, 0, 0, 1];
		//_control ctrlSetActiveColor [1, 0, 0, 1];
		//_control ctrlSetForegroundColor [1, 0, 0, 1];
		//_control ctrlSetTextColor [1, 0, 0, 1];

		_control ctrlCommit 0;

		_counter = _counter + 1;
	};
}forEach pvpfw_commoRose_initializedPages;

["pvpfw_commoRose_opened",[]] call pvpfw_fnc_events_callEH;
