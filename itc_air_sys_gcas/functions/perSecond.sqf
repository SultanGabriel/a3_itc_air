params ["_plane"];
if (getPos _plane # 2 < 1 || !itc_air_gcas_on) exitWith {
	itc_air_gcas_warn = false;
};

private _agl =
getPosATL _plane # 2;

private _gearDown = (_plane animationSourcePhase "gear") < 0.5;

private _collide = [_plane, 1.5] call itc_air_gcas_fnc_checkCollide;
private _terrainWarning = [_plane, 5.5] call itc_air_gcas_fnc_checkCollide;

if (_collide) then {
	itc_air_gcas_warn = true;
	itc_air_gcas_time = CBA_missionTime;

	  // call FWS to set warning

	if (!(_plane getVariable ["itc_air_gearState", true]) && (ITC_AP_mode != 3 || !ITC_AP_isEnabled) && itc_air_agcas_on) then {
		systemChat "AGCAS RECOVER";
		ITC_AP_isEnabled = false;
		_plane spawn {
			sleep 0.05;
			ITC_AP_isEnabled = true;
			[_this, 3] call itc_air_autopilot_fnc_autopilot;
		};
	};
};

private _lastCollide = _plane getVariable ["itc_air_gcas_lastCollide", false];
private _lastTerrain = _plane getVariable ["itc_air_gcas_lastTerrain", false];

if (!(isNil "itc_air_fws_fnc_setWarning") && !_gearDown ) then {
	// Check for collision warnings
	    // When gear is down, warning is inhibited
	if (_collide != _lastCollide) then {
		_plane setVariable ["itc_air_gcas_lastCollide", _collide];
		[_plane, "PULL_UP", _collide] call itc_air_fws_fnc_setWarning;
	};

	if (_terrainWarning != _lastTerrain) then {
		_plane setVariable ["itc_air_gcas_lastTerrain", _terrainWarning];
		[_plane, "TERRAIN", _terrainWarning] call itc_air_fws_fnc_setWarning;
	};
};

// ------------------------------------------------------------------
// ALTITUDE
// Absolute altitude floor, metres ASL.
// ------------------------------------------------------------------

private _altASL =
getPosASL _plane # 2;

private _lastAltASL =
_plane getVariable [
	"itc_air_gcas_lastAltASL",
	_altASL
];

private _descending =
    _altASL < _lastAltASL ; // Descending more than 10m since last frame.

private _alow =
_plane getVariable [
	"itc_air_gcas_alow",
	250
];

private _lowAltArmed =
_plane getVariable [
	"itc_air_gcas_lowAltArmed",
	true
];

private _armed =
_plane getVariable [
	"itc_air_gcas_lowAltArmed",
	true
];

// Rearm after climbing clearly above the threshold.

if (
!_armed &&
_altASL > (_alow + 30)) then {
	_armed = true;
};

// Trigger while below the configured ASL floor.
// do not consume the warning while gear inhibits it.

if (
_lowAltArmed &&
!_gearDown &&
_descending &&
_altASL <= _alow
) then {
	if (!(isNil "itc_air_fws_fnc_setWarning")) then {
		[_plane, "ALTITUDE", true]
		call itc_air_fws_fnc_setWarning;
	};

	_lowAltArmed = false;
};

_plane setVariable [
	"itc_air_gcas_lastAltASL",
	_altASL
];

_plane setVariable [
	"itc_air_gcas_lowAltArmed",
	_lowAltArmed
];