_identifier = param [0,format["%1.%2",random 1000,random 1000]];
_page = param [1,"NOPAGE"];
_text = param [2,"button text"];
_code = param [3,{false}];
_color = param [4,"#ffffff"];
_condition = param [5,{true}];

_pvpfw_commoRose_pageString = format["pvpfw_commoRose_%1_contextual",_page];

_pvpfw_commoRose_pageArray = missionNameSpace getVariable[_pvpfw_commoRose_pageString,[]];
_pvpfw_commoRose_pageArray pushBack [_identifier,_text,_code,_color,_condition];
missionNameSpace setVariable[_pvpfw_commoRose_pageString,_pvpfw_commoRose_pageArray];