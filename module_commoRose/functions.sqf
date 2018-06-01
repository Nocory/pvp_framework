/*
pvpfw_commoRose_removeEntry = {
	_identifier = [_this,0,""] call BIS_fnc_param;
	
	{
		if ((_x select 0) == _identifier) exitWith{
			pvpfw_commoRose_firstPage set[_forEachIndex,objNull];
		};
	}forEach pvpfw_commoRose_firstPage;
	pvpfw_commoRose_firstPage = pvpfw_commoRose_firstPage - [objNull];
};
*/