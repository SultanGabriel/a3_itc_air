params [
    "_display",
    "_slewDir"
];

private _plane =
    vehicle player;

private _weapon =
    _plane getVariable [
        "itc_air_gbu15_activeWeapon",
        objNull
    ];

if (isNull _weapon) exitWith {};


private _lock =
    _weapon getVariable [
        "itc_air_gbu15_lock",
        []
    ];

private _gstab =
    _weapon getVariable [
        "itc_air_gbu15_gstab",
        false
    ];

private _track =
    _weapon getVariable [
        "itc_air_gbu15_track",
        [0,0,0]
    ];

private _dirOffset =
    _weapon getVariable [
        "itc_air_gbu15_dir",
        [0,-5]
    ];

private _slewSpeed =
    _weapon getVariable [
        "itc_air_gbu15_slewSpeed",
        5
    ];


/*
 * Slewing while locked breaks the object lock,
 * but keeps the previous target point stabilized.
 */

if !(_lock isEqualTo []) then {

    _lock params [
        "_targetObject",
        "_targetModelPos"
    ];

    if (!isNull _targetObject) then {

        private _lastPos =
            _targetObject modelToWorldVisualWorld
            _targetModelPos;

        _weapon setVariable [
            "itc_air_gbu15_track",
            ASLtoAGL _lastPos
        ];

        _weapon setVariable [
            "itc_air_gbu15_gstab",
            true
        ];
    };

    _weapon setVariable [
        "itc_air_gbu15_lock",
        []
    ];

    _weapon setVariable [
        "itc_air_gbu15_mode",
        "GSTAB"
    ];

    _gstab = true;
};


/*
 * Current weapon flight direction.
 */

private _velocity =
    velocity _weapon;

private _weaponDir =
    if (
        vectorMagnitude _velocity > 1
    ) then {
        vectorNormalized _velocity
    } else {
        vectorDirVisual _weapon
    };


/*
 * Determine current seeker direction in polar form.
 */

private _slewOrigin =
    _weaponDir call CBA_fnc_vect2Polar;


if (_gstab) then {

    private _weaponPosASL =
        getPosASLVisual _weapon;

    private _trackASL =
        AGLtoASL _track;

    _slewOrigin =
        (
            _weaponPosASL
            vectorFromTo
            _trackASL
        ) call CBA_fnc_vect2Polar;
};


/*
 * Apply pilot input.
 */

private _newDir =
[
    (_slewOrigin # 1)
        + ((_slewDir # 0)
        * (0.01 * _slewSpeed)),

    (_slewOrigin # 2)
        + ((_slewDir # 1)
        * (0.01 * _slewSpeed))
];


private _dirVect =
    [
        1,
        _newDir # 0,
        _newDir # 1
    ] call CBA_fnc_polar2vect;


/*
 * Limit seeker field of regard.
 *
 * Start with ±30 degrees, same general limit
 * used by the Maverick implementation.
 */

private _angle =
    acos (
        _dirVect
        vectorDotProduct
        _weaponDir
    );

if (_angle >= 30) exitWith {};


/*
 * Ground-stabilized slew:
 * move the stabilized world point.
 */

if (_gstab) then {

    private _intersect =
    [
        getPosASLVisual _weapon,
        _newDir # 0,
        _newDir # 1
    ] call itc_air_common_fnc_intersectAtPolar;

    if (!isNil "_intersect") then {

        _weapon setVariable [
            "itc_air_gbu15_track",
            ASLtoAGL _intersect
        ];
    };

} else {

    /*
     * MAN mode stores offsets relative to
     * current weapon flight direction.
     */

    private _weaponPolar =
        _weaponDir call CBA_fnc_vect2Polar;

    private _offset =
    [
        (_newDir # 0) - (_weaponPolar # 1),
        (_newDir # 1) - (_weaponPolar # 2)
    ];

    _weapon setVariable [
        "itc_air_gbu15_dir",
        _offset
    ];
};