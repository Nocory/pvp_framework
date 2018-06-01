pvpfw_logLevel = profileNamespace getVariable["pvpfw_logLevel",0];

pvpfw_colorTime = 2;
pvpfw_timeTillFade = 10;
pvpfw_fadeTime = 5;

pvpfw_log_bufferArrayIndex = 0;
pvpfw_log_bufferArraySize = 9;
pvpfw_log_bufferArray = [];

for "_i" from 0 to pvpfw_log_bufferArraySize do{
	pvpfw_log_bufferArray pushBack ["",0];
};
