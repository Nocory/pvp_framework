/**********
This module can display hints to players, when a certain condition is fullfilled.
Useful as an inGame tutorial
/**********/

pvpfw_hints_array = [];

pvpfw_fnc_hints_registerHint = {
	private["_condition","_hintString","_once","_codeToRun"];
	_condition 		= param [0,{true}];
	_titleString 	= param [1,"There should be a title here"];
	_hintString 	= param [2,"There should be some text here"];
	_once					= param [3,true];
	_codeToRun 		= param [4,{false}];

	pvpfw_hints_array pushBack [_condition,_titleString,_hintString,_once,_codeToRun];
};

if (!hasInterface) exitWith{};

[[],{
	scriptName "pvpfw_hints";
	private["_condition","_hintString","_once","_codeToRun"];

	sleep 2;

	while{true}do{
		waitUntil{sleep 0.16; count pvpfw_hints_array != 0};
		{
			_condition = _x select 0;

			if (call _condition) then{
				_titleString = _x select 1;
				_hintString = _x select 2;
				_once = _x select 3;
				_codeToRun = _x select 4;

				["pvpfw_hint",[_titleString,_hintString]] call BIS_fnc_showNotification;

				if (_once) then{
					pvpfw_hints_array set[_forEachIndex,objNull];
				};

				if (str(_codeToRun) != "{false}") then{
					//_handle = [] spawn _codeToRun;
					[[],_codeToRun,"pvpfw_hints_codeToRun"] call pvpfw_fnc_spawn;
				};
			};
			sleep 0.1;
		}forEach pvpfw_hints_array;
		sleep 0.1;
		pvpfw_hints_array = pvpfw_hints_array - [objNull];

		sleep 0.1;
	};
},"pvpfw_core_hints"] call pvpfw_fnc_spawn;

//[{player != vehicle player},"hi"] call pvpfw_fnc_hints_registerHint;
