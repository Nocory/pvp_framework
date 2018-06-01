_object = _this select 0;
_varVame = _this select 1;
_varValue = _this select 2;
_global = _this select 3;


_object setVariable [_varVame,_varValue,_global];

_variables = _object getVariable["pvpfw_allVariables",[]];
_variables pushBack [_varVame,_varValue,_global];

_object setVariable["pvpfw_allVariables",_variables,false];