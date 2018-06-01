{
  deleteMarker _x;
}forEach (missionNamespace getVariable["pvpfw_wg_system_allMarkers",[]]);
pvpfw_wg_system_allObjectives = [];
pvpfw_wg_system_allMarkers = [];

for "_i" from 1 to 10 do{
  _objMarker = format["pvpfw_wg_obj_%1",_i];
  if(markerColor _objMarker != "")then{
    pvpfw_wg_system_allObjectives pushback _objMarker;

    _objMarker setMarkerAlphaLocal 0;

    _to = 5;

    for "_j" from 1 to _to do{
      _newMarker = createMarkerLocal [format["%1_influence_%2",_objMarker,_j], [0, 0, 0]];

      _newMarker setMarkerAlphaLocal 0.10;
      _newMarker setMarkerShapeLocal "ELLIPSE";
      _markerSize = 250 - ((200 / _to) * _j);
      _newMarker setMarkerSizeLocal [_markerSize,_markerSize];
      _newMarker setMarkerPosLocal markerPos _objMarker;
      _newMarker setMarkerColor "ColorWhite";

      pvpfw_wg_system_allMarkers pushback _newMarker;
    };



    // black
    _newMarker = createMarkerLocal [_objMarker + "_black", [0, 0, 0]];

    _newMarker setMarkerTypeLocal "mil_box_noShadow";
    _newMarker setMarkerDirLocal 45;
    _newMarker setMarkerAlphaLocal 1;
    _markerSize = 0.75;
    _newMarker setMarkerSizeLocal [_markerSize,_markerSize];
    _newMarker setMarkerPosLocal markerPos _objMarker;
    _newMarker setMarkerColor "ColorBlack";
    pvpfw_wg_system_allMarkers pushback _newMarker;

    // white
    _newMarker = createMarkerLocal [_objMarker + "_white_below", [0, 0, 0]];

    _newMarker setMarkerTypeLocal "mil_box_noShadow";
    _newMarker setMarkerDirLocal 45;
    _newMarker setMarkerAlphaLocal 1;
    _markerSize = 0.5;
    _newMarker setMarkerSizeLocal [_markerSize,_markerSize];
    _newMarker setMarkerPosLocal markerPos _objMarker;
    _newMarker setMarkerColor "ColorWhite";
    pvpfw_wg_system_allMarkers pushback _newMarker;

    // white
    _newMarker = createMarkerLocal [_objMarker + "_white", [0, 0, 0]];

    _newMarker setMarkerTypeLocal "mil_box_noShadow";
    _newMarker setMarkerDirLocal 45;
    _newMarker setMarkerAlphaLocal 1;
    _markerSize = 0.35;
    _newMarker setMarkerSizeLocal [_markerSize,_markerSize];
    _newMarker setMarkerPosLocal markerPos _objMarker;
    _newMarker setMarkerColor "ColorWhite";
    pvpfw_wg_system_allMarkers pushback _newMarker;

    // designation
    _newMarker = createMarkerLocal [format["%1_%2",_objMarker,"designation"], [0, 0, 0]];
    //_newMarker setMarkerShapeLocal "ICON";
    _newMarker setMarkerTypeLocal "mil_box_noShadow";
    _newMarker setMarkerAlphaLocal 0.8;
    _newMarker setMarkerSizeLocal [0,0];
    _newMarker setMarkerPosLocal (markerPos _objMarker);
    _newMarker setMarkerColorLocal "ColorBlack";
    _designation = toUpper(pvpfw_common_alphabet select (_i - 1));
    //_newMarker setMarkerText " " + _designation;
    _newMarker setMarkerText (" " + _designation + ": " + markerText _objMarker);
    pvpfw_wg_system_allMarkers pushback _newMarker;
  };
};
