params ["_plane"];

private _UI =
uiNamespace getVariable [
	"ITC_AIR_HUD_UI",
	displayNull
];

if (isNull _UI) exitWith {};

// Only show the indicator on aircraft with the trim System.

private _systems =
_plane getVariable [
	"itc_air_systems_active",
	[]
];

private _show =
"TRIM" in _systems;

(_UI displayCtrl 1020) ctrlShow _show;
(_UI displayCtrl 1021) ctrlShow _show;
(_UI displayCtrl 1022) ctrlShow _show;
(_UI displayCtrl 1023) ctrlShow _show;
(_UI displayCtrl 1024) ctrlShow _show;
(_UI displayCtrl 1025) ctrlShow _show;

if (!_show) exitWith {};

private _pitchTrim =
_plane getVariable [
	"itc_air_trim_pitchTrim",
	0
];

private _pitchConfig =
_plane getVariable [
	"itc_air_trim_pitchConfig",
	[]
];

if (_pitchConfig isEqualTo []) exitWith {};

_pitchConfig params [
	"_maxNoseUpTrim",
	"_maxNoseDownTrim"
];

// Generic takeoff trim range on the nose-up side.

private _takeoffMin = _maxNoseUpTrim * 0.05;

private _takeoffMax = _maxNoseUpTrim * 0.15;

// 
// Map asymmetric trim limits onto one vertical scale.
// 

private _range = _maxNoseUpTrim + _maxNoseDownTrim;

if (_range <= 0) exitWith {};

private _normalized = (_pitchTrim + _maxNoseDownTrim) / _range;

// Nose-up is at the bottom.
_normalized = _normalized max 0 min 1;

// 
// move pointer.
// 

private _scaleX = (safeZoneW / 2) + 0.220;

private _scaleY = (safeZoneH / 2) + 0.085;

private _scaleH = 0.165;

private _pointer = _UI displayCtrl 1022;

_pointer ctrlSetPosition [
	_scaleX,
	_scaleY + (_normalized * _scaleH),
	0.035,
	0.035
];

_pointer ctrlCommit 0;

// 
// position takeoff trim box.
// 0 = top / full nose-down
// 1 = bottom / full nose-up
// 

private _takeoffMinNormalized = (_takeoffMin + _maxNoseDownTrim)/ _range;

private _takeoffMaxNormalized = (_takeoffMax + _maxNoseDownTrim) / _range;

private _takeoffTop =_scaleY +(_takeoffMinNormalized * _scaleH);

private _takeoffBottom =_scaleY +(_takeoffMaxNormalized * _scaleH);

private _takeoffHeight =_takeoffBottom -_takeoffTop;

private _takeoffBox =_UI displayCtrl 1024;

_takeoffBox ctrlSetPosition [
	_scaleX - 0.018,
	_takeoffTop,
	0.012,
	_takeoffHeight
];

_takeoffBox ctrlCommit 0;

//
// Neutral trim marker.
//

private _neutralNormalized =
    _maxNoseDownTrim / _range;

private _neutralY =
    _scaleY +
    (_neutralNormalized * _scaleH);


private _neutralMarker =
    _UI displayCtrl 1025;

_neutralMarker ctrlSetPosition [
    _scaleX - 0.018,
    _neutralY - 0.004,
    0.018,
    0.025
];

_neutralMarker ctrlCommit 0;