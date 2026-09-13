params ["_plane"];

private _UI =
uiNamespace getVariable [
    "ITC_AIR_HUD_UI",
    displayNull
];

if (isNull _UI) exitWith {};


// ---------------------------------------------------------
// Check if the aircraft has the Trim System.
// ---------------------------------------------------------

private _systems =
_plane getVariable [
    "itc_air_systems_active",
    []
];

private _show =
"TRIM" in _systems;


// All trim HUD controls.

private _controls = [
    1020,   // TRIM title
    1021,   // Main vertical scale
    1022,   // Current trim pointer
    1023,   // T/O label
    1024,   // T/O box
    1025,   // Neutral mark
    1026,   // Top cap
    1027,   // Bottom cap
    1028,   // UP label
    1029    // DN label
];


{
    (_UI displayCtrl _x) ctrlShow _show;
}
forEach _controls;


if (!_show) exitWith {};


// ---------------------------------------------------------
// Read trim state.
// ---------------------------------------------------------

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


// Both config values are positive magnitudes.
//
// Example:
//
// maxNoseUpTrim   = 0.20
// maxNoseDownTrim = 0.15
//
// Actual trim range:
//
// +0.20 = full nose up
//  0.00 = neutral
// -0.15 = full nose down

private _range =
_maxNoseUpTrim +
_maxNoseDownTrim;


if (_range <= 0) exitWith {};


// Clamp the value in case runtime config changed.

_pitchTrim =
(_pitchTrim max -_maxNoseDownTrim)
min _maxNoseUpTrim;


// ---------------------------------------------------------
// Main display geometry.
// ---------------------------------------------------------

private _scaleX =
(safeZoneW / 2) + 0.225;

private _scaleY =
(safeZoneH / 2) + 0.070;

private _scaleH = 0.190;
private _scaleW = 0.0025;

private _capW = 0.026;


// ---------------------------------------------------------
// Trim -> HUD position helper.
//
// Returns:
//
// 0 = TOP    = maximum nose-up trim
// 1 = BOTTOM = maximum nose-down trim
//
// This also means that neutral does NOT have to be
// in the visual center.
//
// Example with:
//
// UP   = +0.20
// DOWN = -0.15
//
// neutral is at:
//
// 0.20 / 0.35 = 57.14%
// ---------------------------------------------------------

private _trimToPosition = {

    params ["_trim"];

    private _position =
    (_maxNoseUpTrim - _trim)
    / _range;

    (_position max 0) min 1
};


// ---------------------------------------------------------
// Main vertical scale.
// ---------------------------------------------------------

private _scale =
_UI displayCtrl 1021;

_scale ctrlSetPosition [
    _scaleX,
    _scaleY,
    _scaleW,
    _scaleH
];

_scale ctrlCommit 0;


// ---------------------------------------------------------
// Top cap.
// ---------------------------------------------------------

private _topCap =
_UI displayCtrl 1026;

_topCap ctrlSetPosition [
    _scaleX
        - (_capW / 2)
        + (_scaleW / 2),

    _scaleY,

    _capW,
    0.002
];

_topCap ctrlCommit 0;


// ---------------------------------------------------------
// Bottom cap.
// ---------------------------------------------------------

private _bottomCap =
_UI displayCtrl 1027;

_bottomCap ctrlSetPosition [
    _scaleX
        - (_capW / 2)
        + (_scaleW / 2),

    _scaleY + _scaleH,

    _capW,
    0.002
];

_bottomCap ctrlCommit 0;


// ---------------------------------------------------------
// TRIM title.
// ---------------------------------------------------------

private _title =
_UI displayCtrl 1020;

_title ctrlSetText "TRIM";

_title ctrlSetPosition [
    _scaleX - 0.030,
    _scaleY - 0.060,
    0.060,
    0.030
];

_title ctrlCommit 0;


// ---------------------------------------------------------
// UP label.
//
// Nose-up trim is at the TOP.
// ---------------------------------------------------------

private _up =
_UI displayCtrl 1028;

_up ctrlSetText "UP";

_up ctrlSetPosition [
    _scaleX - 0.017,
    _scaleY - 0.030,
    0.035,
    0.025
];

_up ctrlCommit 0;


// ---------------------------------------------------------
// DN label.
//
// Nose-down trim is at the BOTTOM.
// ---------------------------------------------------------

private _down =
_UI displayCtrl 1029;

_down ctrlSetText "DN";

_down ctrlSetPosition [
    _scaleX - 0.017,
    _scaleY + _scaleH + 0.006,
    0.035,
    0.025
];

_down ctrlCommit 0;


// ---------------------------------------------------------
// Neutral mark.
//
// IMPORTANT:
//
// Do not put this at scaleH / 2.
//
// Its position depends on the aircraft trim limits.
// ---------------------------------------------------------

private _neutralPosition =
[0] call _trimToPosition;

private _neutralY =
_scaleY +
(_neutralPosition * _scaleH);


private _neutral =
_UI displayCtrl 1025;

_neutral ctrlSetPosition [
    _scaleX
        - 0.011
        + (_scaleW / 2),

    _neutralY - 0.001,

    0.024,
    0.002
];

_neutral ctrlCommit 0;


// ---------------------------------------------------------
// Generic takeoff trim range.
//
// For now:
//
//  5% of available nose-up trim
// to
// 25% of available nose-up trim.
//
// We can later move this into aircraft config.
// ---------------------------------------------------------

private _takeoffLow =
_maxNoseUpTrim * 0.05;

private _takeoffHigh =
_maxNoseUpTrim * 0.25;


// Larger positive trim is higher on the HUD.
//
// Therefore:
//
// takeoffHigh = TOP of box
// takeoffLow  = BOTTOM of box

private _takeoffTopPosition =
[_takeoffHigh] call _trimToPosition;

private _takeoffBottomPosition =
[_takeoffLow] call _trimToPosition;


private _takeoffTop =
_scaleY +
(_takeoffTopPosition * _scaleH);

private _takeoffBottom =
_scaleY +
(_takeoffBottomPosition * _scaleH);


private _takeoffHeight =
_takeoffBottom -
_takeoffTop;


// Minimum visible box height.

_takeoffHeight =
_takeoffHeight max 0.012;


private _takeoffBoxW = 0.026;


private _takeoffBox =
_UI displayCtrl 1024;

_takeoffBox ctrlSetPosition [
    _scaleX
        - (_takeoffBoxW / 2)
        + (_scaleW / 2),

    _takeoffTop,

    _takeoffBoxW,
    _takeoffHeight
];

_takeoffBox ctrlCommit 0;


// ---------------------------------------------------------
// T/O label.
// ---------------------------------------------------------

private _takeoffLabel =
_UI displayCtrl 1023;

_takeoffLabel ctrlSetText "T/O";

_takeoffLabel ctrlSetPosition [
    _scaleX - 0.052,

    _takeoffTop
        + (_takeoffHeight / 2)
        - 0.012,

    0.035,
    0.025
];

_takeoffLabel ctrlCommit 0;


// ---------------------------------------------------------
// Current trim pointer.
//
// Positive trim must move UP.
// Negative trim must move DOWN.
// ---------------------------------------------------------

private _currentPosition =
[_pitchTrim] call _trimToPosition;


private _pointerH = 0.035;

private _pointerY =
_scaleY +
(_currentPosition * _scaleH) -
(_pointerH / 2);


private _pointer =
_UI displayCtrl 1022;

_pointer ctrlSetPosition [
    _scaleX + 0.012,
    _pointerY,
    0.035,
    _pointerH
];

_pointer ctrlCommit 0;