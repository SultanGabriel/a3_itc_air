params [
    "_side"
];

_side = toUpper _side;

if !(_side in ["L", "R"]) exitWith {
    false
};


private _vehicle = vehicle player;

private _system =
    format [
        "MFD_%1",
        _side
    ];

if !(
    _system in
    (_vehicle getVariable [
        "itc_air_systems",
        []
    ])
) exitWith {
    false
};


private _variable =
    format [
        "ITC_AIR_MFD_%1",
        _side
    ];

private _layer =
    if (_side == "L") then {
        101
    } else {
        102
    };


if (
    isNil {
        uiNamespace
            getVariable _variable
    }
) then {

    private _mfdType =
        _vehicle getVariable [
            "mfdType",
            "classic"
        ];

    private _resource =
        if (_mfdType == "touch") then {
            format [
                "ITC_AIR_MFD_STL_%1%2",
                _side,
                1
            ]
        } else {
            _variable
        };


    _layer cutRsc [
        _resource,
        "PLAIN",
        -1,
        true
    ];

} else {

    uiNamespace setVariable [
        _variable,
        nil
    ];

    _layer cutText [
        "",
        "PLAIN"
    ];
};


true