params ["_vehicle"];

/*
    Initialize FWS fuel-monitor state.

    Actual fuel warning logic is implemented in monitorFuel.sqf.
*/

_vehicle setVariable [
    "itc_air_fws_fuel_bingoTriggered",
    false
];

true