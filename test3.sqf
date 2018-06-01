/*
0 spawn compile preProcessFileLineNumbers "test3.sqf"
*/

[] call compile preProcessFilelineNumbers "module_wargames\server\initObjectives.sqf";

if (!isNil "pvpfw_wg_handleDebug")then{terminate pvpfw_wg_handleDebug;};

sleep 0.5;

"extDB" callExtension "9:ADD:DB_CUSTOM_V2:custom:Example";
/*
["attack",{

},{true}] call pvpfw_fnc_chatIntercept_addCommand;
*/

pvpfw_wg_objectivesUnderAttack = [];

pvpfw_wg_turnToAttack = "blu";
pvpfw_wg_nextPossibleAttack = 0;

//"Papa_Romeo_5_10_0"
pvpfw_fnc_wg_initAttack = {
	private["_objective"];
	_objective = _this select 0;
	
	_innerMarker = format["pvpfw_obj_%1_inner",_objective];
	_innerMarker setMarkerColor "ColorWhite";
	
	pvpfw_wg_objectivesUnderAttack pushback [_objective,0];
	"extDB" callExtension format["1:custom:update:'%1':'%2':'%3':'%4'","wargamesObjectivesTable",_objective,"controlStatus",0];
	"extDB" callExtension format["1:custom:update:'%1':'%2':'%3':'%4'","wargamesObjectivesTable",_objective,"controlledBy","non"];
};

pvpfw_fnc_wg_selectedObjective = {
	private["_faction","_objective"];
	
	_faction = _this select 0;
	_objective = _this select 1;
	
	if (_faction == pvpfw_wg_turnToAttack && diag_tickTime > pvpfw_wg_nextPossibleAttack)then{
		[_objective] call pvpfw_fnc_wg_initAttack;
	};
};

"pvpfw_pv_wg_selectedObjective" addPublicVariableEventhandler{
	(_this select 1) call pvpfw_fnc_wg_selectedObjective;
};

pvpfw_wg_handleDebug = [] spawn{
	while{true}do{
		{
			_objective = _x select 0;
			_controlStatus = _x select 1;
			
			_objectivePos = markerPos _objective;
			_objectiveSize = (markerSize _objective) select 0;
			
			_bluUnitsInObj = 0;
			_redUnitsInObj = 0;
			
			{
				_pos = getPosASL _x;
				_pos set[2,0];
				_dist = [_pos,_objectivePos] call BIS_fnc_distance2D;
				if (_dist < _objectiveSize)then{
					switch(_x getVariable["pvpfw_playerFaction","NO_FACTION"])do{
						case("blu"):{_bluUnitsInObj = _bluUnitsInObj + 1};
						case("red"):{_redUnitsInObj = _redUnitsInObj + 1};
					};
				};
				sleep 0.01;
			}forEach allUnits;
			
			_bluUnitsInObj = _bluUnitsInObj max 0.001;
			_redUnitsInObj = _redUnitsInObj max 0.001;
			
			_influence = 1 - ((_bluUnitsInObj min _redUnitsInObj) / (_bluUnitsInObj max _redUnitsInObj));
			
			if (_bluUnitsInObj > _redUnitsInObj)then{
				_controlStatus = _controlStatus + _influence;
			}else{
				_controlStatus = _controlStatus - _influence;
			};
			
			pvpfw_wg_objectivesUnderAttack set[_forEachIndex,[_objective,_controlStatus]];
			
			systemChat str[_bluUnitsInObj,_redUnitsInObj];
			systemChat str[_controlStatus,_influence];
			
			"extDB" callExtension format["1:custom:update:'%1':'%2':'%3':'%4'","wargamesObjectivesTable",_objective,"controlStatus",_controlStatus];
			
			if (abs _controlStatus >= 10)then{
				if (_controlStatus > 0)then{
					(format["pvpfw_obj_%1_inner",_objective]) setMarkerColor "ColorBlufor";
					"extDB" callExtension format["1:custom:update:'%1':'%2':'%3':'%4'","wargamesObjectivesTable",_objective,"controlledBy","blu"];
				}else{
					(format["pvpfw_obj_%1_inner",_objective]) setMarkerColor "ColorOpfor";
					"extDB" callExtension format["1:custom:update:'%1':'%2':'%3':'%4'","wargamesObjectivesTable",_objective,"controlledBy","red"];
				};
				pvpfw_wg_objectivesUnderAttack set[_forEachIndex,objNull];
			};
		}forEach pvpfw_wg_objectivesUnderAttack;
		pvpfw_wg_objectivesUnderAttack = pvpfw_wg_objectivesUnderAttack - [objNull];
		
		sleep 0.1;
	};
};

if (_this > 0)then{
	["Papa_Romeo_5_10_0"] call pvpfw_fnc_wg_initAttack;
};