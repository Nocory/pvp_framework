_camera = missionNamespace getVariable["pvpfw_wg_mf_camera","camera" CamCreate [0,0,0]];
missionNamespace setVariable["pvpfw_wg_mf_camera",_camera];
_camera camSetFov 0.6;
_camera cameraEffect ["internal","back"];

_locations = nearestLocations [[5000,5000,0], ["NameCity","NameCityCapital","NameVillage","NameLocal"], 99999];

showCinemaBorder true;

while {true}do{
  _location = selectRandom _locations;
  systemChat str(_location);
  _locationPos = locationPosition _location;
  _locationHeight = getTerrainHeightASL _locationPos;

  _avgX = 0;
  _avgY = 0;
  _nearHouses = (_locationPos nearObjects ["House",200]) + (_locationPos nearObjects ["Ruins_F",100]);
  _nearHousesCount = count _nearHouses;
  {
    _avgX = _avgX + ((getPosASL _x) select 0);
    _avgY = _avgY + ((getPosASL _x) select 1);
  }forEach _nearHouses;

  if (_nearHousesCount != 0)then{
    _avgX = _avgX / _nearHousesCount;
    _avgY = _avgY / _nearHousesCount;
  }else{
    _avgX = _locationPos select 0;
    _avgY = _locationPos select 1;
  };

  // config begin
  _randomDir = random 360;
  _leftToRight = [1,-1] select (random 1);
  _randomAngle = random 90 * _leftToRight;

  systemChat ("angl: " + str(_randomAngle));

  _camPanTime = 30;

  _camDistance = 100 + random 200;
  systemChat ("dist: " + str(_camDistance));
  _targetDistance = 0;

  _camPathLength = 20 + (40 * ((_camDistance - 100) / 200));
  _targetPathLength = (20 + (40 * ((_camDistance - 100) / 200))) * ((90 - (abs _randomAngle)) / 90);
  systemChat ("camr: " + str(_camPathLength));
  systemChat ("trgt: " + str(_targetPathLength));

  _targetExtraHeight = 10;
  _camExtraHeight = 40;
  // config end

  _targetMiddle = [[_avgX,_avgY],_targetDistance,_randomDir] call BIS_fnc_relPos;

  _targetStart = [_targetMiddle,_targetPathLength,_randomDir - 90] call BIS_fnc_relPos;
  _targetStart set[2,((getTerrainHeightASL _targetStart) max (getTerrainHeightASL [_avgX,_avgY])) + _targetExtraHeight];

  _targetEnd = [_targetMiddle,_targetPathLength,_randomDir + 90] call BIS_fnc_relPos;
  _targetEnd set[2,((getTerrainHeightASL _targetEnd) max (getTerrainHeightASL [_avgX,_avgY])) + _targetExtraHeight];

  _camMiddle = [[_avgX,_avgY],_camDistance,_randomDir + 180] call BIS_fnc_relPos;

  _camStart = [_camMiddle,_camPathLength,(_randomDir - 90) - _randomAngle] call BIS_fnc_relPos;
  _camStart set[2,((_targetStart select 2) max (getTerrainHeightASL _camStart)) + _camExtraHeight];

  _camEnd = [_camMiddle,_camPathLength,_randomDir + 90 - _randomAngle] call BIS_fnc_relPos;
  _camEnd set[2,((_targetEnd select 2) max (getTerrainHeightASL _camEnd)) + _camExtraHeight];

  diag_log "---";
  diag_log _locationPos;
  diag_log [_avgX,_avgY];
  diag_log _camMiddle;
  diag_log _camStart;
  diag_log _camEnd;
  diag_log "---";

  _camStart = ASLtoATL _camStart;
  _camEnd = ASLtoATL _camEnd;
  _camera camPreparePos _camStart;

  _targetStart = ASLtoATL _targetStart;
  _targetEnd = ASLtoATL _targetEnd;
  _camera camPrepareTarget _targetStart;

  _camera camCommitPrepared 0;

  sleep 1;

  _camera camPreparePos _camEnd;
  _camera camPrepareTarget _targetEnd;
  _camera camCommitPrepared _camPanTime * 0.8;

  "pvpfw_wg_mf_fadeLayer" cutText ["","BLACK IN" ,_camPanTime * 0.2];

  sleep (_camPanTime * 0.6);

  "pvpfw_wg_mf_fadeLayer" cutText ["","BLACK" ,_camPanTime * 0.2];

  sleep (_camPanTime * 0.2);
};
