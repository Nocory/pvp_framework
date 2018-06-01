/***************************************************************************************
****************************************************************************************
***** A modified version of the BIS stacked eventhandlers for improved performance *****
****************************************************************************************
****************************************************************************************

	Modification description:
	Removed all BIS_fnc_param calls for the fastest possible execution.
	No error should ever be thrown in this function in any circumstance.
	
	Modified the function execution.
	It no longer compiles, but simply calls the saved function.
	
****************************************************************************************
	Author: Nelson Duarte
	Modified By: Conroy
	
	Description:
	This function executes the stacked items, should not be called independently
	
	Parameter(s):
	_this select 0:	STRING	- The onXxx event handler
	_this select 1:	ANY	- The parameters sent to function
	
	Returns:
	BOOLEAN - TRUE
***************************************************************************************/

private ["_event"];

_event = _this select 0;

if (_event == "onEachFrame") then{
	private["_initTime"];
	_initTime = diag_tickTime;
	
	if (!pvpfw_cse_suspendAll) then{
		{
			(_x select 3) call (_x select 2);
		}forEach (missionNameSpace getVariable ["BIS_stackedEventHandlers_" + _event, []]);
	};
	_frameTime = (diag_tickTime - _initTime);
	
	pvpfw_cse_msTotal = pvpfw_cse_msTotal + _frameTime;
	pvpfw_cse_msCount = pvpfw_cse_msCount + 1;
	
	if (diag_tickTime >= pvpfw_cse_nextPerfReport) then{
		pvpfw_cse_msPerFrame = (round((pvpfw_cse_msTotal / pvpfw_cse_msCount) * 1000 * 10000)) / 10000;
		pvpfw_cse_msTotal = 0;
		pvpfw_cse_msCount = 0;
		pvpfw_cse_nextPerfReport = diag_tickTime + pvpfw_cse_reportOnFramePerfEvery;
	};
}else{
	{
		(_x select 3) call (_x select 2);
	}forEach (missionNameSpace getVariable ["BIS_stackedEventHandlers_" + _event, []]);
};

true;
