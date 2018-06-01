
/////////////
// Monitor //
/////////////

pvpfw_perf_monitorServerInfoOnMap = true;
pvpfw_perf_monitorServerCheckInterval = 5;
pvpfw_perf_monitorServerLogEveryX = 6;

/////////////
// CleanUp //
/////////////

pvpfw_perf_cleanUpEnable = true;

// Clean abandonded vehicles
pvpfw_perf_cleanUpAbandonded = false; // true or false, depending on wether you want abandoned vehicles to be deleted
pvpfw_perf_cleanUpAbandonedFromFaction = ["BLU_F","OPF_F","IND_F"]; // Vehicles from these factions will be cleaned up
pvpfw_perf_cleanUpAbandonedRadius = 200; // If no unit is closer than the specified distance, the removal countdown will start
pvpfw_perf_CleanUpAbandondTimer = 10; // The vehicle will be removed after the specified time
pvpfw_perf_cleanUpDontCleanUpAroundMarkers = ["respawn_west","respawn_east","respawn_civilian","respawn_vehicle_guerrila"]; //do not clean abandoned vehicles around these markers
pvpfw_perf_cleanUpDontCleanUpAroundDistance = 500; // Dont clean if the vehicle is in this range of one of the above markers.
pvpfw_perf_cleanUpOnlyTheseTypes = []; // [] to clean all types

// Clean destroyed vehicles
pvpfw_perf_cleanUpVehicleRadius = 25; // Destroyed vehicles cleanup timer will start if no unit is closer than this
pvpfw_perf_cleanUpVehicleTimer = 30;

// Clean bodies
pvpfw_perf_cleanUpBodyTimer = 30; // Bodies will be removed after the specified amount of seconds

// Clean Explosives
pvpfw_perf_cleanUpExplosivesMaxTimer = 120 * 60; //delete if explosive was alive for that long
pvpfw_perf_cleanUpExplosivesMinTimer = 60 * 60; //delete if no unit has been in range for this time
pvpfw_perf_cleanUpExplosivesRadius = 100;

// Clean Weaponholders
pvpfw_perf_cleanUpWeaponholdersTimer = 60 * 60;
pvpfw_perf_cleanUpWeaponholdersResetRadius = 10;