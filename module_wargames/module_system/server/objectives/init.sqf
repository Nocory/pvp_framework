
pvpfw_wg_system_allObjectives = [];
pvpfw_wg_system_achievedObjectives = [];

pvpfw_wg_system_objectivesBlu = [];
pvpfw_wg_system_objectivesRed = [];

pvpfw_wg_system_addObjective = {
  _arguments = _this select 0;
  _code = _this select 1;
  _id = _this select 2;

  pvpfw_wg_system_allObjectives pushBack [_arguments,_code,_id];
};

[[],{
  while{true}do{
    {
      if ((_x select 1) call (_x select 2))then{
        pvpfw_wg_system_achievedObjectives pushBackUnique (_x select 3);
        publicVariable "pvpfw_wg_system_achievedObjectives";
        pvpfw_wg_system_allObjectives set[_forEachIndex,objNull]; // mark for removal
      };
    }forEach pvpfw_wg_system_allObjectives;
    sleep 0.1;
    pvpfw_wg_system_allObjectives = pvpfw_wg_system_allObjectives - [objNull];
    sleep 0.171;
  };
},"pvpfw_wg_system_objCheckLoop"] call pvpfw_fnc_spawn;

pvpfw_wg_system_getObjectiveText = {
  _bluObjectives = "";

  "C:\Steam\steamapps\common\Arma 3\Addons\ui_f_data\a3\ui_f\data\Map\Diary\Icons\taskSucceeded_ca.paa"
  "C:\Steam\steamapps\common\Arma 3\Addons\ui_f_data\a3\ui_f\data\Map\Diary\Icons\taskFailed_ca.paa"

  {

    _bluObjectives = _bluObjectives + format["%1 <br>",]
  }forEach pvpfw_wg_system_objectivesBlu;
};

[] call compile preProcessFilelineNumbers "module_wargames\module_system\server\objectives\kill.sqf";
[] call compile preProcessFilelineNumbers "module_wargames\module_system\server\objectives\capture.sqf";
[] call compile preProcessFilelineNumbers "module_wargames\module_system\server\objectives\establishBase.sqf";
[] call compile preProcessFilelineNumbers "module_wargames\module_system\server\objectives\escort.sqf";
