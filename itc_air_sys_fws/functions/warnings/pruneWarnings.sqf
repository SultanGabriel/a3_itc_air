params ["_vehicle"];

private _now =
    CBA_missionTime;

private _warnings = +(
    _vehicle getVariable [
        "itc_air_fws_active",
        []
    ]
);

_warnings = _warnings select {

    _x params [
        "_id",
        "_acknowledged",
        "_expiry",
        "_lastPlayed"
    ];

    _expiry < 0 ||
    _expiry > _now
};

_vehicle setVariable [
    "itc_air_fws_active",
    _warnings
];

true