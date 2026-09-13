params ["_vehicle"];

private _id =
    _vehicle getVariable [
        "itc_air_fws_currentId",
        ""
    ];

if (_id isEqualTo "") exitWith {
    false
};

private _occurrence = _vehicle getVariable ["itc_air_fws_currentOccurrence", -1];


// Update warning playback state
// -------------------------------------------------------------------------

private _warnings = +(
    _vehicle getVariable [
        "itc_air_fws_active",
        []
    ]
);

private _index = _warnings findIf {
    (_x # 0) isEqualTo _id && {(_x # 1) isEqualTo _occurrence}
};

if (_index >= 0) then {

    private _warning =
        _warnings # _index;

    _warning set [
        3,
        CBA_missionTime
    ];

    _warnings set [
        _index,
        _warning
    ];

    _vehicle setVariable [
        "itc_air_fws_active",
        _warnings
    ];
};


// Clear audio state
// -------------------------------------------------------------------------

_vehicle setVariable [
    "itc_air_fws_currentId",
    ""
];

_vehicle setVariable ["itc_air_fws_currentOccurrence", -1];

_vehicle setVariable [
    "itc_air_fws_currentPriority",
    -1
];

_vehicle setVariable [
    "itc_air_fws_currentSequence",
    []
];

_vehicle setVariable [
    "itc_air_fws_currentIndex",
    -1
];

_vehicle setVariable [
    "itc_air_fws_currentSource",
    objNull
];

true
