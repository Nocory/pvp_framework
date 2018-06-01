/*
if (!isNil "myTowHandle")then{terminate myTowHandle};myTowHandle = [] execVM "module_logistic\tow\tow.sqf";
*/

if (isNil "pvpfw_tow_sphere1")then{
	pvpfw_tow_sphere1 = "Sign_Sphere10cm_F" createVehicleLocal [0,0,0];
	pvpfw_tow_sphere2 = "Sign_Sphere10cm_F" createVehicleLocal [0,0,0];
};

_towedBy = [_this,0,objNull] call BIS_fnc_param;
_towedObject = [_this,1,objNull] call BIS_fnc_param;

if (isNull _towedBy || isNull _towedObject) exitWith{};

_boundingBox = boundingBoxReal _towedBy;
_mostRear = ((_boundingBox select 0) select 1);
pvpfw_tow_sphere1 attachTo [_towedBy,[0,(_mostRear * 1.1) - 1,0]];

_boundingBox = boundingBoxReal _towedObject;
_mostFront = ((_boundingBox select 1) select 1);
pvpfw_tow_sphere2 attachTo [_towedObject,[0,(_mostFront * 1.1) + 1,0]];

pvpfw_tow_towedBy = _towedBy;
pvpfw_tow_towedObject = _towedObject;

pvpfw_tow_towedObject engineOn true;

["pvpfw_tow_test", "onEachFrame", {
	//if (diag_frameNo % 2 != 0) exitWith{};
	_dir = [pvpfw_tow_towedObject,pvpfw_tow_sphere1] call BIS_fnc_dirTo;
	pvpfw_tow_towedObject setDir _dir;
	//pvpfw_tow_towedObject setVectorDirAndUp [vectorDir _dir,(surfaceNormal getPosATL pvpfw_tow_towedObject)];
	//pvpfw_tow_towedObject setVectorDir (vectorDir pvpfw_tow_towedObject);
	//_towedObject setVectorUp (surfaceNormal getPosATL _towedObject);
	
	_vecDir = vectorDir pvpfw_tow_towedObject;
	_distToSphere = ((pvpfw_tow_sphere1 distance pvpfw_tow_sphere2) - 0.5) max 0;
	
	if ((pvpfw_tow_sphere1 distance pvpfw_tow_towedBy) > (pvpfw_tow_sphere2 distance pvpfw_tow_towedBy))then{
		_vecDir = _vecDir vectorMultiply -(_distToSphere * 5);
	}else{
		_vecDir = _vecDir vectorMultiply (_distToSphere * 5);
	};
	
	//_vecDir set[2,(_vecDir select 2) + 2];
	
	pvpfw_tow_towedObject setVelocity _vecDir;
}] call BIS_fnc_addStackedEventHandler;