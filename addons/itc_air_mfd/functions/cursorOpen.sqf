private _vehicle = vehicle player;

if !(
    "UFC" in
    (_vehicle getVariable [
        "itc_air_systems",
        []
    ])
) exitWith {
    false
};


if !(isNull curatorCamera) exitWith {
    false
};


// Do not create a second control display.

if !(isNull (findDisplay 1501)) exitWith {
    true
};


private _parent = findDisplay 46;

if (isNull _parent) exitWith {
    false
};


private _displayClass =
    _vehicle getVariable [
        "mfdButtons",
        ""
    ];

if (_displayClass == "") exitWith {
    false
};


setMousePosition [
    0.5,
    0.5
];

_parent createDisplay _displayClass;


true