
systemChat str(_this);

_activePage = param [0,""];
_pageEntryIndex = param [1,-1];
_controlIndex = param [2,-1];

_activePageArray = missionNameSpace getVariable[format["pvpfw_commoRose_%1",_activePage],[]];
_codeOrArray = (_activePageArray select _pageEntryIndex) select 2;

switch(typeName _codeOrArray)do{
	case("CODE"):{
		[] call _codeOrArray;
	};
	case("ARRAY"):{
		[pvpfw_commoRose_allControls select _controlIndex,_codeOrArray] call pvpfw_fnc_commoRose_showSubButtons;
	};
	default{}
};