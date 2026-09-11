params ["_vehicle"];

private _fuel =
fuel _vehicle;

// FIXME i have those shitty / 100 there bcs input does not accept decimals so had to revert
private _bingoFuel =
_vehicle getVariable [
	"itc_air_fws_bingoFuel",
	20
];

_bingoFuel = _bingoFuel / 100;

private _lowFuel =
_vehicle getVariable [
	"itc_air_fws_lowFuel",
	10
];

_lowFuel = _lowFuel / 100;

private _fuelData = +(
_vehicle getVariable [
	"itc_air_fws_fuelData",
	[
		_fuel,
		_fuel,
		CBA_missionTime,
		0,
		-1
	]
]
);

_fuelData params [
	"_lastFuel",
	"_sampleFuel",
	"_sampleTime",
	"_burnRate",
	"_endurance"
];

// -------------------------------------------------------------------------
// BINGO
// Event when we cross the configured threshold.
// -------------------------------------------------------------------------

if (
_lastFuel > _bingoFuel &&
_fuel <= _bingoFuel
) then {
	[_vehicle, "FUEL_BINGO", true]
	call itc_air_fws_fnc_setWarning;
};

// -------------------------------------------------------------------------
// LOW fuel
// Persistent state.
// -------------------------------------------------------------------------

private _isLowFuel = _fuel <= _lowFuel;
[_vehicle, "FUEL_LOW", _isLowFuel] call itc_air_fws_fnc_setWarning;

systemChat format [
    "FUEL %1 LOW %2 ACTIVE %3",
    _fuel,
    _lowFuel,
    _isLowFuel
];
// -------------------------------------------------------------------------
// fuel consumption estimate
// -------------------------------------------------------------------------

private _now = CBA_missionTime;

// fuel increased -> refuel.
// Restart the measurement window.

if (_fuel > (_sampleFuel + 0.001)) then {
	_sampleFuel = _fuel;
	_sampleTime = _now;

	_burnRate = 0;
	_endurance = -1;
} else {
	private _elapsed =
	_now - _sampleTime;

	    // Update the estimate every 15 seconds.
	if (_elapsed >= 15) then {
		private _fuelUsed =
		_sampleFuel - _fuel;

		_burnRate =
		if (_fuelUsed > 0) then {
			(_fuelUsed / _elapsed) * 60
		} else {
			0
		};

		_endurance =
		if (_burnRate > 0.0001) then {
			_fuel / _burnRate
		} else {
			-1
		};

		_sampleFuel = _fuel;
		_sampleTime = _now;
	};
};

// -------------------------------------------------------------------------
// Save compact state
// -------------------------------------------------------------------------

_vehicle setVariable [
	"itc_air_fws_fuelData",
	[
		_fuel,
		_sampleFuel,
		_sampleTime,
		_burnRate,
		_endurance
	]
];

true