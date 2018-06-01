
pvpfw_missionFlow_lockedInBlu = [];
pvpfw_missionFlow_lockedInRed = [];

[[],"module_missionFlow\server\start.sqf","pvpfw_missionFlow_server_start"] call pvpfw_fnc_spawn;
[[],"module_missionFlow\server\stop.sqf","pvpfw_missionFlow_server_end"] call pvpfw_fnc_spawn;