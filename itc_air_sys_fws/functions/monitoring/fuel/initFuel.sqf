params ["_vehicle"];

private _fuel = fuel _vehicle;
private _now = CBA_missionTime;

// Private measurement history: previous quantity, window quantity/time.
_vehicle setVariable ["itc_air_fws_fuelSample", [_fuel, _fuel, _now]];

_vehicle setVariable [
    "itc_air_fws_fuelData",
    [
        _fuel,              // quantityFraction
        -1,                 // burnRatePerMinute: unavailable until sampled
        -1,                 // enduranceMinutes: unavailable
        _now                // sampledAt
    ]
];

true
