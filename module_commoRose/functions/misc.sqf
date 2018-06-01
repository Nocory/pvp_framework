pvpfw_fnc_commoRose_resetRose = {
	{ctrlDelete _x}forEach pvpfw_commoRose_allControls;
	pvpfw_commoRose_allControls resize 0;
};

pvpfw_fnc_commoRose_clearSubEntries = {
	{ctrlDelete _x}forEach pvpfw_commoRose_allSubControls;
	pvpfw_commoRose_allSubControls resize 0;
};

pvpfw_fnc_commoRose_close = {
	pvpfw_commoRose_delayOpeningTill = diag_tickTime + 1;
	closeDialog 0;
	pvpfw_commoRose_active = false;
};