
if (isNil "pvpfw_record_readCount") then{pvpfw_record_readCount = 0;};

_ident = [_this,0,""] call BIS_fnc_param;

_bluDB = "pvpfw_record_blu" + _ident;
_redDB = "pvpfw_record_red" + _ident;
_carDB = "pvpfw_record_car" + _ident;
_apcDB = "pvpfw_record_apc" + _ident;
_cvDB = "pvpfw_record_cv" + _ident;
_airDB = "pvpfw_record_air" + _ident;

_array = [];
while{(count ([_bluDB, "pvpfw_record", format["index_%1",pvpfw_record_readCount], "ARRAY"] call iniDB_read)) != 0}do{
	
	// inf
	_array resize 0;
	{
		_x resize 2;
		_array pushBack _x;
	}forEach ([_bluDB, "pvpfw_record", format["index_%1",pvpfw_record_readCount], "ARRAY"] call iniDB_read);
	missionNamespace setVariable[format["pvpfw_record_inf_blu_%1",pvpfw_record_readCount],+_array];
	//[_array,"blu"] call pvpfw_drawInfClusters;
	
	_array resize 0;
	{
		_x resize 2;
		_array pushBack _x;
	}forEach ([_redDB, "pvpfw_record", format["index_%1",pvpfw_record_readCount], "ARRAY"] call iniDB_read);
	missionNamespace setVariable[format["pvpfw_record_inf_red_%1",pvpfw_record_readCount],+_array];
	//[_array,"red"] call pvpfw_drawInfClusters;
	
	// VEHICLES
	{
		_DBArray = ([_x select 0, "pvpfw_record", format["index_%1",pvpfw_record_readCount], "ARRAY"] call iniDB_read);
		_vehicleType = _x select 1;
		{
			_array resize 0;
			{
				_array pushBack [[_x select 0,_x select 1],_x select 2];
			}forEach (_x select 0);
			missionNamespace setVariable[format["pvpfw_record_%1_%2_%3",_vehicleType,_x select 1,pvpfw_record_readCount],+_array];
		}forEach [
			[_DBArray select 0,"blu"],
			[_DBArray select 1,"red"]
		];
	}forEach[
		[_carDB,"car"],
		[_apcDB,"apc"],
		[_cvDB,"cv"],
		[_airDB,"air"]
	];
	/*
	// fl
	_array resize 0;
	{
		_array set[_forEachIndex,_x];
	}forEach ([_flDB, "pvpfw_record", format["index_%1",pvpfw_record_readCount], "ARRAY"] call iniDB_read);
	missionNamespace setVariable[format["pvpfw_record_fl_%1",pvpfw_record_readCount],+_array];
	*/
	systemChat format["pvpfw_record_readCount prep %1",pvpfw_record_readCount];
	pvpfw_record_readCount = pvpfw_record_readCount + 1;
	if ((diag_frameNo % 100) == 0)then{
		sleep 0.01;
	};
	
	if (pvpfw_record_readCount == pvpfw_record_preCalcEnd) exitWith{};
};

pvpfw_record_readCount = pvpfw_record_readCount - 1;