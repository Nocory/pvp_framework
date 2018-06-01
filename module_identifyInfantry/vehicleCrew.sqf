
// TODO proper crew display control and not just a hint

[[],{
	scriptName "pvpfw_ii_showVehicleCrew";

	private["_hintText","_vehicle"];

	while{true}do{
		waitUntil{sleep 1;vehicle player != player};
		while{vehicle player != player}do{
			_hintText = "Vehicle Crew:<br/>";
			_vehicle = vehicle player;
			{
				if (alive _x) then{
					switch(true)do{
						case(_x == driver _vehicle):{
							_hintText = _hintText + "<br/>" + "<img image='\a3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_driver_ca.paa' align='left'/>" + (name _x);
						};
						case(_x == commander _vehicle):{
							_hintText = _hintText + "<br/>" + "<img image='\a3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_commander_ca.paa' align='left'/>" + (name _x);
						};
						case(_x == gunner _vehicle):{
							_hintText = _hintText + "<br/>" + "<img image='\a3\ui_f\data\IGUI\RscIngameUI\RscUnitInfo\role_gunner_ca.paa' align='left'/>" + (name _x);
						};
						default{
							_hintText = _hintText + "<br/>" + (name _x);
						};
					};
				};
				sleep 0.05;
			}forEach (crew _vehicle);

			hintSilent (parseText _hintText);

			sleep 0.12;
		};
		hintSilent "";
	};
},"pvpfw_ii_showVehicleCrew"] call pvpfw_fnc_spawnOnce;
