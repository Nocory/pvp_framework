/*
	Based on "BIS_fnc_drawMinefields" by Karel Moricky
	
	Adapted to display the approximate control area of groups of infantry units
*/

//--- Init
_positions = _this select 0;
_side = _this select 1;
_clusterDis = 200;
_buffer = _clusterDis * 0.1;



// forEach forEach.. i know
_markerInfo = [];
{
	_posX = 0;
	_posY = 0;
	
	_x resize 2;
	_pos = _x;
	_inRange = [];
	_furthest = _pos;
	_average = 0;
	{
		_x resize 2;
		_distance = _pos distance _x;
		if (_distance < _clusterDis) then{
			_inRange pushBack _x;
			if (_distance > (_pos distance _furthest))then{
				_furthest = _x;
			};
			_average = _average + _distance;
		};
	}forEach _positions;
	
	if (count _inRange > 1) then{
		{
			_posX = _posX + (_x select 0);
			_posY = _posY + (_x select 1);
		}forEach _inRange;
		
		_posX = _posX / (count _inRange);
		_posY = _posY / (count _inRange);
		
		_average = _average / (count _inRange);
		_dir = [_pos,_furthest] call bis_fnc_dirTo;
		//systemChat str[_dir,_pos,_furthest];
		_markerInfo pushBack [[_posX,_posY],[(_pos distance _furthest),((_pos distance _furthest) + _average) * 1.2],_dir];
	};
}forEach _positions;

missionNamespace setVariable[format["pvpfw_record_infArea_%1_%2",_side,pvpfw_record_readCount],+_markerInfo];