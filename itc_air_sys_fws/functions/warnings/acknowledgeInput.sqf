// functions/input/acknowledgeInput.sqf

private _vehicle = vehicle player;

if (
    _vehicle getVariable [
        "itc_air_fws_initialized",
        false
    ]
) then {
    [_vehicle]
        call itc_air_fws_fnc_acknowledge;
};