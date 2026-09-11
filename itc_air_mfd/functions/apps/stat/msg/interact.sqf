params ["_display", "_btn"];

if (_btn == "R5") exitWith {

    private _vehicle = vehicle player;

    if !(isNil "itc_air_fws_fnc_acknowledge") then {
        [_vehicle] call itc_air_fws_fnc_acknowledge;
    };

    true
};

switch (_btn) do {

    case "T2": {
        _display setVariable ["page", "nav"];
    };

    case "T3": {
        _display setVariable ["page", "stat"];
    };

    case "T4": {
        _display setVariable ["page", "sys"];
    };
};

false