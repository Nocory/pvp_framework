//////////////////////////
// General PVPFW Config //
//////////////////////////

pvpfw_cfg_adminIDs = [
	"76561197970638727", //Conroy
	"00000000000000000", //Name
	"00000000000000000" //Name
];

pvpfw_cfg_playerIsAdmin = (getPlayerUID player) in pvpfw_cfg_adminIDs || !isMultiplayer;
pvpfw_cfg_playerIsOpCom = !isMultiplayer; //in mp players have to authenticate

////////////////////////
// Mission Parameters //
////////////////////////

if (isNil "paramsArray")then{missionNamespace setVariable["paramsArray",[]]};

pvpfw_cfg_trainingEnabled = true;

pvpfw_cfg_year = 2020;
pvpfw_cfg_month = 7;
pvpfw_cfg_day = 6;
pvpfw_cfg_hour = 12;
pvpfw_cfg_minute = 0;

pvpfw_cfg_terrainViewDistance = 6000;
pvpfw_cfg_objectViewDistance = 2000;

pvpfw_cfg_missionDuration = 180; // value in minutes

pvpfw_cfg_weather = "clear";
pvpfw_cfg_weatherForecast = "clear";
pvpfw_cfg_weatherChangeDuration = 90; // value in minutes

if (isServer) then{
	setDate [pvpfw_cfg_year, pvpfw_cfg_month, pvpfw_cfg_day, pvpfw_cfg_hour, pvpfw_cfg_minute];
};

if (!isDedicated) then{
	setTerrainGrid 6.25;
	setViewDistance pvpfw_cfg_terrainViewDistance;
	setObjectViewDistance pvpfw_cfg_objectViewDistance;
	enableSaving [false, false];
	enableSentences false;
	player enableAttack false;
	player disableConversation true;
};
