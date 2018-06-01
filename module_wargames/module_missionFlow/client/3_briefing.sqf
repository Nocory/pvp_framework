ppEffectDestroy (missionNamespace getVariable["pvpfw_wg_mf_ppLayerIntro1",-1]);
ppEffectDestroy (missionNamespace getVariable["pvpfw_wg_mf_ppLayerIntro2",-1]);

pvpfw_wg_mf_ppLayerIntro1 = ppEffectCreate ["ColorCorrections", 638];
pvpfw_wg_mf_ppLayerIntro1 ppEffectAdjust [
  0.5,
	0.2,
	0,
	0, 0, 0, 0,
	0.5, 0.5, 0.5, 0,
	1, 1, 1, 0
];
pvpfw_wg_mf_ppLayerIntro1 ppEffectCommit 0.5;
pvpfw_wg_mf_ppLayerIntro1 ppEffectEnable true;

pvpfw_wg_mf_ppLayerIntro2 = ppEffectCreate ["dynamicBlur", 636];
pvpfw_wg_mf_ppLayerIntro2 ppEffectAdjust [1.0];
pvpfw_wg_mf_ppLayerIntro2 ppEffectCommit 0.5;
pvpfw_wg_mf_ppLayerIntro2 ppEffectEnable true;

["<t size='1.4' font='PuristaSemiBold' shadow='2' color='#ffffffff'>" + "Operation Aegis" + "</t>",0,0.4,0,2,0,"pvpfw_wg_mf_briefing_opName"] spawn BIS_fnc_dynamicText;

sleep 0;

["<t size='1.4' font='PuristaSemiBold' shadow='2' color='#ffffffff'>" + "Stand By For Mission Briefing" + "</t>",0,0.7,0,2,0,"pvpfw_wg_mf_briefing_standby"] spawn BIS_fnc_dynamicText;

sleep 1;

pvpfw_wg_mf_ppLayerIntro1 ppEffectAdjust [
	1,
	1,
	0,
	0, 0, 0, 0,
	1, 1, 1, 1,
	0.299, 0.587, 0.114, 0
];
pvpfw_wg_mf_ppLayerIntro1 ppEffectCommit 5;

pvpfw_wg_mf_ppLayerIntro2 ppEffectAdjust [0.0];
pvpfw_wg_mf_ppLayerIntro2 ppEffectCommit 5;

sleep 6;

ppEffectDestroy (missionNamespace getVariable["pvpfw_wg_mf_ppLayerIntro1",-1]);
ppEffectDestroy (missionNamespace getVariable["pvpfw_wg_mf_ppLayerIntro2",-1]);
