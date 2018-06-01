/*
[1] call compile preProcessFileLineNumbers "test.sqf"
*/

myArray = [];
for "_i" from 0 to 1999 do{
	myArray pushback str(_i);
};
myArray set[0,objNull];

_fnc1 = {
	myArray set[0,objNull];
	myArray = myArray - [objNull];
};

_fnc2 = {
	['
		myArray = [];
		myArray set[0,objNull];
		myArray = myArray - [objNull];
	',[],1000] call BIS_fnc_codePerformance;
};

_fnc3 = {
	['

	',[],1000] call BIS_fnc_codePerformance;
};

_fnc4 = {
	['

	',[],1000] call BIS_fnc_codePerformance;
};

switch(_this select 0)do{
	case(1):{
		if (typeName _fnc1 == "CODE")then{
			_fnc1 = str(_fnc1);
		};

		[_fnc1,[],1000] call BIS_fnc_codePerformance;
	};
	case(2):{
		[] call _fnc2;
	};
	case(3):{
		[] call _fnc3;
	};
	case(4):{
		[] call _fnc4;
	};
};
