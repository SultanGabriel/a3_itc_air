params [
    "_direction",
    "_active"
];

private _vehicle = vehicle player;

if (
    _active &&
    {
        !(
            "SOI" in
            (_vehicle getVariable [
                "itc_air_systems",
                []
            ])
        )
    }
) exitWith {
    false
};

if (isNil "itc_air_soi_slewHeld") then {
    itc_air_soi_slewHeld = [
        false, // UP
        false, // doWN
        false, // LEFT
        false // RIGHT
    ];
};

private _index =
[
    "UP",
    "DOWN",
    "LEFT",
    "RIGHT"
] find (toUpper _direction);

if (_index < 0) exitWith {
    false
};

itc_air_soi_slewHeld set [
    _index,
    _active
];

itc_air_soi_slewHeld params [
    "_up",
    "_down",
    "_left",
    "_right"
];

private _slew = [0, 0, 0];

if (_up) then {
    _slew = _slew vectorAdd [0, 1, 0];
};

if (_down) then {
    _slew = _slew vectorAdd [0, -1, 0];
};

if (_left) then {
    _slew = _slew vectorAdd [-1, 0, 0];
};

if (_right) then {
    _slew = _slew vectorAdd [1, 0, 0];
};

if (_slew isEqualTo [0, 0, 0]) then {
    ITC_AIR_SOI_SLEW = nil;
} else {
    ITC_AIR_SOI_SLEW = _slew;
};

false