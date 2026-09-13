params ["_plane"];

private _height = (_plane getVariable ["itc_air_gcas_landingInhibitHeight", 300]) max 0;
((_plane animationSourcePhase "gear") < 0.5) && {(getPosATL _plane # 2) < _height}
