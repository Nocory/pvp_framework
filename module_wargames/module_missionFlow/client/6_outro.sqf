

ppEffectDestroy (missionNamespace getVariable["pvpfw_wg_mf_ppLayer",-1]);
ppEffectDestroy (missionNamespace getVariable["pvpfw_wg_mf_ppLayer1",-1]);
ppEffectDestroy (missionNamespace getVariable["pvpfw_wg_mf_ppLayer2",-1]);
ppEffectDestroy (missionNamespace getVariable["pvpfw_wg_mf_ppLayer3",-1]);

0 fadeMusic 1;
0 fadeSound 1;

ctrlDelete (uiNamespace getVariable["pvpfw_wg_mf_bgCtrl",controlNull]);

"pvpfw_wg_mf_layer1" cutText ["","PLAIN",0];
"pvpfw_wg_mf_layer2" cutText ["","PLAIN",0];
"pvpfw_wg_mf_layer3" cutText ["","PLAIN",0];

removeMissionEventHandler ["Draw3D",missionNamespace getVariable["pvpfw_wg_mf_outroMarkUnits3DEH",-1]];

_camera = missionNamespace getVariable["pvpfw_wg_mf_cameraOutro",objNull];
_camera cameraEffect ["terminate","back"];
camDestroy _camera;
missionNamespace setVariable["pvpfw_wg_mf_cameraOutro",nil];

player enableSimulation true;


0 fadeMusic 0;
16 fadeMusic 0.75;
playMusic ["BackgroundTrack01_F_EPC", 14];
//playMusic ["Short01_Defcon_Three", 0];
//playMusic ["LeadTrack03_F_Bootcamp", 0];

sleep 13.5;

"pvpfw_wg_mf_fadeLayer" cutText ["","BLACK", 10];
10 fadeSound 0;
sleep 10;

removeAllWeapons player;

player action ["engineOff", vehicle player];
player action ["autoHover", vehicle player];
player enableSimulation false;
(vehicle player) enableSimulation false;




//"pvpfw_wg_mf_fadeLayer" cutText ["","BLACK" ,1];

sleep 1;


_camera = "camera" CamCreate (eyePos player);
missionNamespace setVariable["pvpfw_wg_mf_cameraOutro",_camera];
//_camera = objNull;

// config
_checks = 53;
_steps = 5;
_camDist = 500;
_camHeight = 200;

// determine cam-center
_centerX = 0;
_centerY = 0;
_targetCount = 0.001;

for "_i" from 0 to 10 do{
  _objMarker = format["pvpfw_wg_obj_%1",_i];
  if(markerColor _objMarker != "")then{
    _markerPos = markerPos _objMarker;
    _centerX = _centerX + (_markerPos select 0);
    _centerY = _centerY + (_markerPos select 1);
    _targetCount = _targetCount + 1;
  };
};

_center = [_centerX / _targetCount,_centerY / _targetCount,20];

_heightArray = [];
for "_i" from 0 to _checks do{
  _heightArray pushBack 99999;
};
_lowestHeight = 99999;
_lowestDir = 0;

for "_i" from 0 to (360 + (_checks * _steps)) step _steps do{
  _checkPos = [_center,_camDist,_i] call BIS_fnc_relPos;

  _heightArray set[(_i / _steps) % _checks,getTerrainHeightASL _checkPos];

  _heightSum = 0;
  {
    _heightSum = _heightSum + _x;
  }forEach _heightArray;

  _averageHeight = _heightSum / _checks;
  if (_averageHeight < _lowestHeight)then{
    _lowestHeight = _averageHeight;
    _lowestDir = _i - (_steps * ((_checks - 1) / 2));
  };
};

systemChat ("dir: " + str(_lowestDir));

removeMissionEventHandler ["Draw3D",missionNamespace getVariable["pvpfw_ii_missionEH",-1]];




sleep 0.25;
/*
{
  _x hideObject false;
}forEach (allUnits + vehicles);
*/
pvpfw_wg_mf_outroMarkUnits3DInit = diag_tickTime;
pvpfw_wg_mf_outroMarkUnits3DEH = addMissionEventHandler ["Draw3D",{
  _elapsed = diag_tickTime - pvpfw_wg_mf_outroMarkUnits3DInit;
  //_alpha = 0 max (1 min (_elapsed / 2) min (15.5 - _elapsed));
  //_alpha = 0 max (1 min (_elapsed / 2));
  _alpha = 1;

  //if (_alpha == 0)exitWith{removeMissionEventHandler ["Draw3D",missionNamespace getVariable["pvpfw_wg_mf_outroMarkUnits3DEH",-1]];};

  //systemChat str(_alpha);

  {
    //if (alive _x && (count (worldToScreen _pos)) != 0 && _x == vehicle _x)then{
    if (alive _x && _x distance player < 1000 && _x == vehicle _x)then{
      _icon = "";
      _iconPrefix = "b";
      _size = 1;
      _color = [1,1,1,_alpha];

      switch(_x getVariable ["pvpfw_customSide",side _x])do{
        case(blufor):{
          _color = [0,0.3,0.6,_alpha];
          _iconPrefix = "b";
        };
        case(opfor):{
          _color = [0.5,0,0,_alpha];
          _iconPrefix = "o";
        };
      };

      switch(true)do{
        case(_x isKindOf "CAManBase"):{
          _icon = "\a3\ui_f\data\map\markers\nato\" + _iconPrefix + "_inf.paa";
          _size = 0.66;
        };
        case(_x isKindOf "Tank"):{
          _icon = "\a3\ui_f\data\map\markers\nato\" + _iconPrefix + "_armor.paa";
        };
        // TODO class is probably not "apc"
        case(_x isKindOf "APC"):{
          _icon = "\a3\ui_f\data\map\markers\nato\" + _iconPrefix + "_mech_inf.paa";
        };
        case(_x isKindOf "Car"):{
          _icon = "\a3\ui_f\data\map\markers\nato\" + _iconPrefix + "_motor_inf.paa";
        };
        case(_x isKindOf "Air"):{
          _icon = "\a3\ui_f\data\map\markers\nato\" + _iconPrefix + "_air.paa";
        };
      };

      drawIcon3D [_icon, _color, ASLtoATL visiblePositionASL _x, _size, _size, 0, "", 0];
    };
  }forEach (allUnits + vehicles);
}];

_startDir = _lowestDir - 20;

_camPos = [_center,_camDist,_startDir] call BIS_fnc_relPos;
_camPos set[2,_camHeight];

_camera camCommand "inertia off";
_camera camPreparePos _camPos;
_camera camPrepareTarget _center;
_camera camPrepareFov 0.6;
_camera camCommitPrepared 0;


_camera cameraEffect ["internal","back"];

"pvpfw_wg_mf_fadeLayer" cutText ["","BLACK IN" ,5];

cameraEffectEnableHUD true;

[[_camera,_center,_camDist,_camHeight,_startDir],{
  _camera = param [0, objNull];
  _center = param [1, [0,0,0]];
  _camDist = param [2, 500];
  _camHeight = param [3, 200];
  _startDir = param [4, 0];

  _dirOffset = 0;

  while{!isNull _camera}do{
    _dirOffset = _dirOffset + 1;

    _camPos = [_center,_camDist,_startDir + _dirOffset] call BIS_fnc_relPos;
    _camPos set[2,_camHeight];

    _camera camPreparePos _camPos;
    _camera camCommitPrepared 1.6;

    //cameraEffectEnableHUD true;

    sleep 1.5;
  };
},"pvpfw_wg_mf_outroUAVCam"] call pvpfw_fnc_spawnOnce;

//5 fadeMusic 0;
//5 fadeSound 0;



sleep 15;
//"pvpfw_wg_mf_fadeLayer" cutText ["","BLACK" ,5];

"pvpfw_wg_mf_fadeLayer" cutText ["","WHITE OUT", 0.1];

sleep 0.15;
removeMissionEventHandler ["Draw3D",missionNamespace getVariable["pvpfw_wg_mf_outroMarkUnits3DEH",-1]];

pvpfw_wg_mf_ppLayer3 = ppEffectCreate ["ColorCorrections", 638];
pvpfw_wg_mf_ppLayer3 ppEffectAdjust [
  0.5,
	0.2,
	0,
	0, 0, 0, 0,
	0.5, 0.5, 0.5, 0,
	1, 1, 1, 0
];
pvpfw_wg_mf_ppLayer3 ppEffectCommit 0;
pvpfw_wg_mf_ppLayer3 ppEffectEnable true;

pvpfw_wg_mf_ppLayer1 = ppEffectCreate ["dynamicBlur", 636];
pvpfw_wg_mf_ppLayer1 ppEffectAdjust [1.0];
pvpfw_wg_mf_ppLayer1 ppEffectCommit 0;
pvpfw_wg_mf_ppLayer1 ppEffectEnable true;



//sleep 1;
/*
_camera = missionNamespace getVariable["pvpfw_wg_mf_cameraOutro",objNull];
_camera cameraEffect ["terminate","back"];
camDestroy _camera;
missionNamespace setVariable["pvpfw_wg_mf_cameraOutro",nil];
*/
//removeMissionEventHandler ["Draw3D",missionNamespace getVariable["pvpfw_wg_mf_outroMarkUnits3DEH",-1]];

_duration = 30;

_text = "<t size='0.8' font='PuristaBold' shadow='2' color='#ffffffff' underline='false'>" + "Operation Summary" + "</t>";
[_text,0,0.0,_duration,0,0,"pvpfw_wg_mf_layer1"] spawn BIS_fnc_dynamicText;
//sleep 4;

_text = "" +
// Funds
"<t size='0.6' font='PuristaBold' shadow='2' color='#ffffffff'>" + "Fielded Assets<br/><br/></t>" +
"<t size='0.5' font='PuristaMedium' shadow='2' color='#ff1F75FE'>" +  str(123) + "</t>" +
"<t size='0.5' font='PuristaMedium' shadow='2' color='#ffffffff'>" +  "  |Men|  " + "</t>" +
"<t size='0.5' font='PuristaMedium' shadow='2' color='#ffED1C24'>" +  str(123) + "<br/>" +
"<t size='0.5' font='PuristaMedium' shadow='2' color='#ff1F75FE'>" +  str(123) + "</t>" +
"<t size='0.5' font='PuristaMedium' shadow='2' color='#ffffffff'>" +  "  |Light|  " + "</t>" +
"<t size='0.5' font='PuristaMedium' shadow='2' color='#ffED1C24'>" +  str(123) + "<br/>" +
"<t size='0.5' font='PuristaMedium' shadow='2' color='#ff1F75FE'>" +  str(123) + "</t>" +
"<t size='0.5' font='PuristaMedium' shadow='2' color='#ffffffff'>" +  "  |Heavy|  " + "</t>" +
"<t size='0.5' font='PuristaMedium' shadow='2' color='#ffED1C24'>" +  str(123) + "<br/>" +
"<t size='0.5' font='PuristaMedium' shadow='2' color='#ff1F75FE'>" +  str(123) + "</t>" +
"<t size='0.5' font='PuristaMedium' shadow='2' color='#ffffffff'>" +  "  |Air|  " + "</t>" +
"<t size='0.5' font='PuristaMedium' shadow='2' color='#ffED1C24'>" +  str(123) + "<br/><br/></t>" +
// Obj
"<t size='0.6' font='PuristaBold' shadow='2' color='#ffffffff'>" + "Battle Result<br/><br/></t>" +
"<t size='0.5' font='PuristaMedium' shadow='2' color='#ff1F75FE'>" +  str(123) + "</t>" +
"<t size='0.5' font='PuristaMedium' shadow='2' color='#ffffffff'>" +  "  -  " + "</t>" +
"<t size='0.5' font='PuristaMedium' shadow='2' color='#ffED1C24'>" +  str(123) + "<br/><br/></t>";

[_text,0,0.2,_duration,0,0,"pvpfw_wg_mf_layer2"] spawn BIS_fnc_dynamicText;

"pvpfw_wg_mf_fadeLayer" cutText ["","WHITE IN", 0.1];

sleep 20;

_text = "<t size='0.8' font='PuristaBold' shadow='2' color='#ffffffff'>" + "Debrief starts now." + "</t>";
[_text,0,0.9,_duration - 20,1,0,"pvpfw_wg_mf_layer3"] spawn BIS_fnc_dynamicText;

sleep 70;

//"pvpfw_wg_mf_fadeLayer" cutText ["","BLACK" ,5];

systemChat "msg";

["<t size='0.5' font='PuristaMedium' shadow='2' color='#ffffffff'>" +  "it's ok, you can disconnect now" + "</t>",0,0.9,99,1,0,"pvpfw_wg_mf_layer3"] spawn BIS_fnc_dynamicText;
