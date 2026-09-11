params ["_vehicle"];

if !(
    (_vehicle getVariable [
        "itc_air_fws_currentId",
        ""
    ]) isEqualTo ""
) then {
    [_vehicle]
        call itc_air_fws_fnc_interruptCurrent;
};

_vehicle setVariable [
    "itc_air_fws_initialized",
    false
];

_vehicle setVariable [
    "itc_air_fws_active",
    []
];

true