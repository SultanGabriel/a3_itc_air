// FIXME later change this to be a pretty state output of all active warnings, sorted by priority and time. 
params ["_vehicle"];

if !(
    _vehicle getVariable [
        "itc_air_fws_initialized",
        false
    ]
) exitWith {
    []
};

+(
    _vehicle getVariable [
        "itc_air_fws_active",
        []
    ]
)