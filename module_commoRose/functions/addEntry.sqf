_identifier = param [0,format["%1.%2",random 1000,random 1000]];
_page = param [1,"NOPAGE"];
_text = param [2,"button text"];
_codeOrArray = param [3,{false}];

_color = if (typeName _codeOrArray == "ARRAY")then[{"#aaaaff"},{"#ffffff"}];

//_color = param [4,_color];
_condition = param [5,{true}];
_addOnlyIf = param [6,{true}];

if !([] call _addOnlyIf) exitWith{};

_pvpfw_commoRose_pageString = format["pvpfw_commoRose_%1",_page];

_pvpfw_commoRose_pageArray = missionNameSpace getVariable[_pvpfw_commoRose_pageString,[]];
_pvpfw_commoRose_pageArray pushBack [_identifier,_text,_codeOrArray,_color,_condition];
missionNameSpace setVariable[_pvpfw_commoRose_pageString,_pvpfw_commoRose_pageArray];

//also add the page to the array of initialized pages if it's not in there yet
_alreadyDefined = false;
{
	if ((_x select 0) == _page) exitWith{_alreadyDefined = true};
}forEach pvpfw_commoRose_initializedPages;

if (!_alreadyDefined) then{
	pvpfw_commoRose_initializedPages pushBack [_page,{true},_page];
};