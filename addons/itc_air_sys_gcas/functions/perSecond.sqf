params ["_plane"];


// if the plane is grounded, GCAS cannot produce airborne warnings. 
// Exit early to avoid unnecessary calculations and to reset any active warnings.
if (getPosATL _plane # 2 < 1 || !itc_air_gcas_on) exitWith {
	itc_air_gcas_warn = false;
	_plane setVariable [
		"itc_air_gcas_altitudeSample",
		[getPosASL _plane # 2, CBA_missionTime, 0]
	];
	_plane setVariable [
		"itc_air_gcas_sinkRateSample",
		[velocity _plane # 2, CBA_missionTime, false]
	];
	if (!isNil "itc_air_fws_fnc_setWarning") then {
		{[_plane, _x, false] call itc_air_fws_fnc_setWarning} forEach ["PULL_UP", "TERRAIN", "ALTITUDE", "TOO_LOW_GEAR", "SINK_RATE"];
	};
};

private _collide = [_plane, 1.5] call itc_air_gcas_fnc_checkCollide;
private _terrainWarning = [_plane, 5.5] call itc_air_gcas_fnc_checkCollide;

if (_collide) then {
	private _ap = [_plane] call itc_air_autopilot_fnc_ap_getState;

	private _apEnabled = _ap getOrDefault [
		"enabled",
		false
	];

	private _apMode = _ap getOrDefault [
		"mode",
		"ALT"
	];

	if (!(_plane getVariable ["itc_air_gearState", true]) &&
		{!(_apEnabled && {_apMode isEqualTo "AGCAS"})} &&
		{itc_air_agcas_on}
	) then {

		systemChat "AGCAS RECOVER";

		[ "AGCAS", _plane ] call itc_air_autopilot_fnc_ap_setMode;

		if (!_apEnabled) then {
			[_plane,true] call itc_air_autopilot_fnc_ap_enable;
		};
	};
};

if (isNil "itc_air_fws_fnc_setWarning") exitWith {};
if !(_plane getVariable ["itc_air_fws_initialized", false]) exitWith {};

// Idempotent publication also restores ongoing hazards after an FWS restart.
// Gear/landing inhibits audio only; detected hazards remain visible.
[_plane, "PULL_UP", _collide] call itc_air_fws_fnc_setWarning;
[_plane, "TERRAIN", _terrainWarning] call itc_air_fws_fnc_setWarning;

// ------------------------------------------------------------------
// ALTITUDE
// Absolute altitude floor, metres ASL.
// ------------------------------------------------------------------

private _altASL =
getPosASL _plane # 2;

private _now = CBA_missionTime;
private _altitudeSample = _plane getVariable [
	"itc_air_gcas_altitudeSample",
	[_altASL, _now, 0]
];
_altitudeSample params ["_sampleASL", "_sampleTime", "_altitudeTrend"];

// Use an older ASL sample and ignore small position noise.
if ((_now - _sampleTime) >= 0.5) then {
	private _altitudeDelta = _altASL - _sampleASL;
	_altitudeTrend = if (_altitudeDelta < -2) then {
		-1
	} else {
		if (_altitudeDelta > 2) then {1} else {0}
	};
	_altitudeSample = [_altASL, _now, _altitudeTrend];
	_plane setVariable ["itc_air_gcas_altitudeSample", _altitudeSample];
};

private _alow =
_plane getVariable [
	"itc_air_gcas_alow",
	250
];

private _warnings = _plane getVariable ["itc_air_fws_active", []];
private _active = (_warnings findIf {(_x # 0) isEqualTo "ALTITUDE"}) >= 0;
// One occurrence below the ASL floor, rearmed after the existing 30 m margin.
private _unsafe = if (_active) then {
	_altASL <= (_alow + 30)
} else {
	_altitudeTrend < 0 && {_altASL <= _alow}
};
[_plane, "ALTITUDE", _unsafe] call itc_air_fws_fnc_setWarning;

// ------------------------------------------------------------------
// TOO LOW GEAR
// AGL and BI retractable-gear state.
// ------------------------------------------------------------------

// private _agl = getPosATL _plane # 2;
// private _gearRetracting = getNumber (
// 	configFile >> "CfgVehicles" >> typeOf _plane >> "gearRetracting"
// ) > 0;
// private _gearPhase = if (_gearRetracting) then {
// 	_plane animationSourcePhase "gear"
// } else {
// 	0
// };
// private _gearUnsafe = _gearRetracting && {_gearPhase > 0.05};
// private _gearWarningHeight = _plane getVariable [
// 	"itc_air_gcas_landingInhibitHeight",
// 	300
// ];
// private _lowGearActive = (_warnings findIf {(_x # 0) isEqualTo "TOO_LOW_GEAR"}) >= 0;
// private _lowGearWarning = if (_lowGearActive) then {
// 	_gearUnsafe && {_agl < (_gearWarningHeight + 10)}
// } else {
// 	_gearUnsafe && {_agl < _gearWarningHeight}
// };
// [_plane, "TOO_LOW_GEAR", _lowGearWarning] call itc_air_fws_fnc_setWarning;

// ------------------------------------------------------------------
// SINK RATE
// Actual world vertical velocity, filtered across two time samples.
// ------------------------------------------------------------------

private _sinkRate = _plane getVariable ["itc_air_gcas_sinkRate", 35];
private _sinkRateHysteresis = _plane getVariable ["itc_air_gcas_sinkRateHysteresis", 4];
private _sinkRateHeight = _plane getVariable ["itc_air_gcas_sinkRateHeight", 300];
private _verticalSpeed = velocity _plane # 2;
private _sinkRateSample = _plane getVariable [
	"itc_air_gcas_sinkRateSample",
	[_verticalSpeed, _now, false]
];
_sinkRateSample params ["_sampleVerticalSpeed", "_sampleVerticalTime", "_sinkRateState"];

// Require two unsafe or two recovered samples; retain the state in between.
if ((_now - _sampleVerticalTime) >= 0.5) then {
	private _clearSinkRate = _sinkRate - _sinkRateHysteresis;
	_sinkRateState = if (
		_sampleVerticalSpeed < -_sinkRate && {_verticalSpeed < -_sinkRate}
	) then {
		true
	} else {
		if (
			_sampleVerticalSpeed > -_clearSinkRate && {_verticalSpeed > -_clearSinkRate}
		) then {false} else {_sinkRateState}
	};
	_sinkRateSample = [_verticalSpeed, _now, _sinkRateState];
	_plane setVariable ["itc_air_gcas_sinkRateSample", _sinkRateSample];
};

private _sinkRateActive = (_warnings findIf {(_x # 0) isEqualTo "SINK_RATE"}) >= 0;
private _sinkRateWarning = if (_sinkRateActive) then {
	_sinkRateState && {_agl < (_sinkRateHeight + 10)}
} else {
	_sinkRateState && {_agl < _sinkRateHeight}
};
[_plane, "SINK_RATE", _sinkRateWarning] call itc_air_fws_fnc_setWarning;
