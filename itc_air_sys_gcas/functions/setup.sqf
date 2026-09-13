params ["_vehicle"];
itc_air_gcas_time = 0;
[_vehicle, [missionNameSpace, "itc_air_gcas_on", true, "GCAS ON", {}, "cycle", [false, true]]] call itc_air_common_fnc_addOption;

if ("AGCAS" in (_vehicle getVariable ["itc_air_systems", []])) then {
	[_vehicle, [missionNameSpace, "itc_air_agcas_on", true, "AGCAS ON", {}, "cycle", [false, true]]] call itc_air_common_fnc_addOption;
};

// Low altitude warning threshold.
// Internal value is metres.

[_vehicle, [
	_vehicle,
	"itc_air_gcas_alow",
	_vehicle getVariable ["itc_air_gcas_alow", 250],
	"ALOW M",
	{},
	"UFC",
	{
		_this >= 0 && _this <= 3000
	},
	true
]] call itc_air_common_fnc_addOption;

// Aircraft-local GCAS parameter, metres above terrain
private _gcasConfig = itc_air_seat_config >> "gcas";
private _landingInhibitHeight = getNumber (_gcasConfig >> "lowGearHeight");
if (_landingInhibitHeight <= 0) then {
	_landingInhibitHeight = 300
};
_vehicle setVariable [
	"itc_air_gcas_landingInhibitHeight",
	_vehicle getVariable ["itc_air_gcas_landingInhibitHeight", _landingInhibitHeight]
];

private _altASL = getPosASL _vehicle # 2;
_vehicle setVariable [
	"itc_air_gcas_altitudeSample",
	[_altASL, CBA_missionTime, 0]
];

_vehicle setVariable [
	"itc_air_gcas_sinkRateSample",
	[velocity _vehicle # 2, CBA_missionTime, false]
];

private _sinkRate = getNumber (_gcasConfig >> "sinkRate");
if (_sinkRate <= 0) then {
	_sinkRate = 35
};
private _sinkRateHysteresis = getNumber (_gcasConfig >> "sinkRateHysteresis");
if (_sinkRateHysteresis <= 0) then {
	_sinkRateHysteresis = 4
};
private _sinkRateHeight = getNumber (_gcasConfig >> "sinkRateHeight");
if (_sinkRateHeight <= 0) then {
	_sinkRateHeight = 300
};

_vehicle setVariable [
	"itc_air_gcas_sinkRate",
	_vehicle getVariable ["itc_air_gcas_sinkRate", _sinkRate]
];
_vehicle setVariable [
	"itc_air_gcas_sinkRateHysteresis",
	_vehicle getVariable ["itc_air_gcas_sinkRateHysteresis", _sinkRateHysteresis]
];
_vehicle setVariable [
	"itc_air_gcas_sinkRateHeight",
	_vehicle getVariable ["itc_air_gcas_sinkRateHeight", _sinkRateHeight]
];

private _lowSpeed = getNumber (itc_air_seat_config >> "gcas" >> "lowSpeed");
if (_lowSpeed <= 0) then {
	_lowSpeed = 70
};
private _lowSpeedHysteresis = getNumber (itc_air_seat_config >> "gcas" >> "lowSpeedHysteresis");
if (_lowSpeedHysteresis <= 0) then {
	_lowSpeedHysteresis = 5
};

_vehicle setVariable [
	"itc_air_gcas_lowSpeed",
	_vehicle getVariable ["itc_air_gcas_lowSpeed", _lowSpeed]
];
_vehicle setVariable [
	"itc_air_gcas_lowSpeedHysteresis",
	_vehicle getVariable ["itc_air_gcas_lowSpeedHysteresis", _lowSpeedHysteresis]
];