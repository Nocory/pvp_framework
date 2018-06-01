_camera = missionNamespace getVariable["pvpfw_wg_mf_camera",objNull];

_camera cameraEffect ["terminate","back"];
camDestroy _camera;

"pvpfw_wg_mf_fadeLayer" cutFadeOut 1;
