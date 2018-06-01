_newAssetsPerHour = 5000;
_newAssetsEachNSeconds = 10;

_assetsPerTick = (_newAssetsPerHour / 60 / 60) * 10;

_nextCheck = floor diag_tickTime + _newAssetsEachNSeconds;
waitUntil {sleep 0.01; diag_tickTime > _nextCheck};

while{true}do{
  pvpfw_wg_assets_funds_blu = pvpfw_wg_assets_funds_blu + _assetsPerTick;
  pvpfw_wg_assets_funds_red = pvpfw_wg_assets_funds_red + _assetsPerTick;

  publicVariable "pvpfw_wg_assets_funds_blu";
  publicVariable "pvpfw_wg_assets_funds_red";

  waitUntil {sleep 0.12; diag_tickTime > _nextCheck};
	_nextCheck = floor diag_tickTime + _newAssetsEachNSeconds;
};
