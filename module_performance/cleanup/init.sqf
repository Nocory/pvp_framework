/****************************************
*****************************************

Module: Cleanup
Global-var-shortcut: pvpfw_cleanup_
Author: Conroy

Description:

Provides functions for other scripts to clean up dead bodies and destroyed or abandoned vehicles (as well as possibly other things in the future)

Especially the respawn scripts will make use of this.
As soon as a vehicle is considered to be on respawn it can be passed to the modules cleanup function. The module will then take care of everything

you can "setVariable["pvpfw_cleanUp_keep",true]" on any object, to exempt it from the cleanup
*****************************************
****************************************/

// Client
if (hasInterface) then{
	[[],{
		waitUntil{!isNull player};

		player removeEventHandler ["InventoryClosed", missionNamespace getVariable["pvpfw_cleanUp_invClosedEH",-1]];
		player removeEventHandler ["Fired", missionNamespace getVariable["pvpfw_cleanUp_firedEH",-1]];

		pvpfw_cleanUp_invClosedEH = player addEventHandler ["InventoryClosed",{
			_container = (_this select 1);

			if (((typeOf _container) in ["GroundWeaponHolder","WeaponHolderSimulated"]) && {!(_container getVariable["pvpfw_perf_cleanUpObjHandledByServer",false])})then{
				_container spawn{
					private["_container"];
					_container = _this;

					sleep 1;
					if !(isNull _container)then{
						_container setVariable["pvpfw_perf_cleanUpObjHandledByServer",true,true];
						pvpfw_pv_perf_cleanUpThisContainer = _container;
						publicVariableServer "pvpfw_pv_perf_cleanUpThisContainer";
						["cleanup: sending container to server",2] call pvpfw_fnc_log_show;
					};
				};
			};

			false
		}];

		pvpfw_cleanUp_firedEH = player addEventHandler ["Fired",{
			if ((_this select 1) == "Put")then{
				pvpfw_pv_perf_cleanUpThisPutObject = _container;
				publicVariableServer "pvpfw_pv_perf_cleanUpThisPutObject";
				["cleanup: sending put object to server",2] call pvpfw_fnc_log_show;
			};
		}];
	},"pvpfw_cleanUp_client"] call pvpfw_fnc_spawnOnce;
};

// Server
if (isServer) then{
	if (pvpfw_perf_cleanUpAbandonded) then{
		[[],"module_performance\cleanup\cleanAbandonded.sqf","pvpfw_cleanAbandonded_server"] call pvpfw_fnc_spawnOnce;
	};

	[[],"module_performance\cleanup\cleanUp.sqf","pvpfw_cleanUp_server"] call pvpfw_fnc_spawnOnce;
};
