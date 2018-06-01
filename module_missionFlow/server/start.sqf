
waitUntil{sleep 0.1;pvpfw_missionFlow_adminsReady && (pvpfw_missionFlow_bluforReady || pvpfw_missionFlow_opforReady)};

waitUntil{
	uiSleep 1;
	
	pvpfw_missionFlow_secsTillStart = pvpfw_missionFlow_secsTillStart - 1;
	publicVariable "pvpfw_missionFlow_secsTillStart";
	
	(pvpfw_missionFlow_secsTillStart == 0) || (pvpfw_missionFlow_bluforReady && pvpfw_missionFlow_opforReady && pvpfw_missionFlow_adminsReady);
};

pvpfw_missionFlow_secsTillStart = 0;
publicVariable "pvpfw_missionFlow_secsTillStart";