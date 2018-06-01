private["_ticksPerInterval","_processThisFrame","_unit"];


_ticksPerInterval = (_this select 0) * 0.9;
_processThisFrame = (tf_allUnitsCount / _ticksPerInterval) max 2;

tf_processExtraAllUnits = (tf_processExtraAllUnits % 1) + (_processThisFrame % 1);

for "_i" from 1 to ((floor _processThisFrame) + (floor tf_processExtraAllUnits)) do{
	_unit = tf_allUnitsArray select tf_allUnitsIndex;
	
	_sharingAChannel = false;
	
	if (side _unit == playerSide)then{
		_remoteSRMain = _unit getVariable["pvpfw_tfr_currentSRFreqMain","DEFAULT"];
		_remoteSRAdd = _unit getVariable["pvpfw_tfr_currentSRFreqAdditional","DEFAULT"];
		_remoteLRMain = _unit getVariable["pvpfw_tfr_currentLRFreqMain","DEFAULT"];
		_remoteLRAdd = _unit getVariable["pvpfw_tfr_currentLRFreqAdditional","DEFAULT"];
		
		_playerSRMain = player getVariable["pvpfw_tfr_currentSRFreqMain","DEFAULT"];
		_playerSRAdd = player getVariable["pvpfw_tfr_currentSRFreqAdditional","DEFAULT"];
		_playerLRMain = player getVariable["pvpfw_tfr_currentLRFreqMain","DEFAULT"];
		_playerLRAdd = player getVariable["pvpfw_tfr_currentLRFreqAdditional","DEFAULT"];
		
		// Compare SR main channel
		//if ((_playerSRMain == _remoteSRMain || (!isMultiplayer && random 1 > 0.5)) && {_unit != player})then{
		if (_playerSRMain == _remoteSRMain && {_unit != player})then{
			_unitName = _unit getVariable ["pvpfw_markers_shortPlayerName",name _unit];
			//if (_unit getVariable["pvpfw_tfr_talkingOnSR",false] || (!isMultiplayer && random 1 > 0.5)) then{
			if (_unit getVariable["pvpfw_tfr_talkingOnSR",false]) then{
				pvpfw_tfr_unitsInSameSRChannel = pvpfw_tfr_unitsInSameSRChannel + _unitName + "<br/>";
			}else{
				pvpfw_tfr_unitsInSameSRChannel = pvpfw_tfr_unitsInSameSRChannel + format["<t color='#77ffffff'>%1</t><br/>",_unitName];
			};
			
			_sharingAChannel = true;
		}else{
			if (
				//check LR
				_playerLRMain == _remoteLRMain || {_playerLRMain == _remoteLRAdd}
				||
				{_playerLRAdd == _remoteLRMain} || {_playerLRAdd == _remoteLRAdd}
				||
				//check rest of the SR channels
				{_playerSRMain == _remoteSRAdd}
				||
				{_playerSRAdd == _remoteSRMain} || {_playerSRAdd == _remoteSRAdd}
			)then{
				_sharingAChannel = true;
			};
		};
	};
	
	if (player distance _unit < 65 || _sharingAChannel) then{
		tf_unitsToCalculate pushback _unit;
	};
	
	tf_allUnitsIndex = tf_allUnitsIndex + 1;
	
	if (tf_allUnitsIndex >= tf_allUnitsCount) exitWith{
		tf_allUnitsCheckDone = true;
	};
};