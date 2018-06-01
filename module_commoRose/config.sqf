
pvpfw_commoRose_holdKeyFor = 0.2;

pvpfw_commoRose_innerDirStep = 25;
pvpfw_commoRose_outerDirStep = 10;
pvpfw_commoRose_innerDist = 2.25;
pvpfw_commoRose_outerDist = 3;

pvpfw_commoRose_baseIDC = 6566;

if (!isNil "pvpfw_commoRose_initializedPages")then{
	{
		missionNamespace setVariable[format["pvpfw_commoRose_%1",_x select 0],nil];
		missionNamespace setVariable[format["pvpfw_commoRose_%1_contextual",_x select 0],nil];
	}forEach pvpfw_commoRose_initializedPages;
};
