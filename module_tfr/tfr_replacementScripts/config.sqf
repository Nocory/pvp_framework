
waitUntil{!isNil "pvpfw_param_trainingEnabled"};
pvpfw_tfr_enabled = if (pvpfw_param_trainingEnabled == 0 || !isMultiplayer)then[{true},{false}];

pvpfw_tfr_longRangeRadioUnitTypes = [
	"B_officer_F","B_Soldier_TL_F","B_Soldier_SL_F",
	"O_officer_F","O_Soldier_TL_F","O_Soldier_SL_F",
	"O_crew_F","B_crew_F"
]