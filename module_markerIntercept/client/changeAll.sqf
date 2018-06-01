{
	if (([_x,0,14] call BIS_fnc_trimString) == "_USER_DEFINED #") then{
		[_x,false] call pvpfw_fnc_mi_change;
	};
}forEach allmapMarkers;