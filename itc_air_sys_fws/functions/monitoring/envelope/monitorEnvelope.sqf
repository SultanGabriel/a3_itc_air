params ["_vehicle"];

if !(
    _vehicle getVariable [
        "itc_air_fws_initialized",
        false
    ]
) exitWith {};

// Envelope monitoring is independent of GCAS and uses the existing aircraft
// speed source. Grounded aircraft cannot produce these airborne warnings.
if (getPosATL _vehicle # 2 < 1) exitWith {
    [_vehicle, "SPEED", false] call itc_air_fws_fnc_setWarning;
    [_vehicle, "STALL", false] call itc_air_fws_fnc_setWarning;
};

private _speed = vectorMagnitude (velocity _vehicle);
private _flap = _plane animationSourcePhase "flap";
private _lowSpeed = _vehicle getVariable ["itc_air_gcas_lowSpeed", 70];
private _lowSpeedHysteresis = _vehicle getVariable ["itc_air_gcas_lowSpeedHysteresis", 5];
private _warnings = _vehicle getVariable ["itc_air_fws_active", []];
private _speedActive = (_warnings findIf {(_x # 0) isEqualTo "SPEED"}) >= 0;

private _speedWarning = if (_speedActive) then {
    _speed < (_lowSpeed + _lowSpeedHysteresis)
} else {
    _speed < _lowSpeed
};

// INHIBIT SPEED warning when flaps are deployed. 
if (_flap > 0.05) then {
    _speedWarning = false;
};

[_vehicle, "SPEED", _speedWarning] call itc_air_fws_fnc_setWarning;

// STALL waits for runtime verification of the BI AoA source and scale.
