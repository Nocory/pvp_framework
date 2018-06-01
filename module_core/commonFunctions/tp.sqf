
["pvpfw_notification_infoShort",["","Click The Map To Teleport"]] call BIS_fnc_showNotification;

onMapSingleClick '
	if (player != vehicle player)then{
		_pos set[2,(getPos (vehicle player)) select 2];
	};
	
	(vehicle player) setPos _pos;

	{
		player reveal _x;
	}forEach ((position player) nearObjects 100);
	
	onMapSingleClick ""
';