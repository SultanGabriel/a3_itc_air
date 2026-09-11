params ["_vehicle"];

/*
    Initialize FWS fuel-monitor state.

    Actual fuel warning logic is implemented in monitorFuel.sqf.
*/

private _fuel = fuel _vehicle;

_vehicle setVariable [
    "itc_air_fws_fuelData",
    [
        _fuel,              // last fuel
        _fuel,              // sample start fuel
        CBA_missionTime,    // sample start time
        0,                  // burn rate, fuel fraction / minute
        -1                  // endurance, minutes
    ]
];

true