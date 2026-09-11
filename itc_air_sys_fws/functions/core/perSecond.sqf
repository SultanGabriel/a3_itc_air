params ["_plane"];

if !(
    _plane getVariable [
        "itc_air_fws_initialized",
        false
    ]
) exitWith {};


// Simple generic aircraft monitoring.
// Specialist systems such as GCAS, EW and FCS remain external producers.

[_plane] call itc_air_fws_fnc_monitorFuel;
[_plane] call itc_air_fws_fnc_monitorDamage;