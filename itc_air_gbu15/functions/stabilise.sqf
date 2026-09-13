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


/*
 * If locked:
 * first TMS DOWN clears the object lock,
 * but keeps the last point stabilized.
 */

if !(_lock isEqualTo []) exitWith {

    _lock params [
        "_targetObject",
        "_targetModelPos"
    ];

    if (!isNull _targetObject) then {

        private _posASL =
            _targetObject
            modelToWorldVisualWorld
            _targetModelPos;

        _weapon setVariable [
            "itc_air_gbu15_track",
            ASLtoAGL _posASL
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
};


/*
 * If already GSTAB:
 * TMS DOWN returns to MAN.
 */

private _gstab =
    _weapon getVariable [
        "itc_air_gbu15_gstab",
        false
    ];

if (_gstab) exitWith {

    _weapon setVariable [
        "itc_air_gbu15_gstab",
        false
    ];

    _weapon setVariable [
        "itc_air_gbu15_mode",
        "MAN"
    ];
};


/*
 * MAN -> GSTAB.
 *
 * Calculate current seeker LOS from
 * bomb flight direction + seeker offset.
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


private _weaponPolar =
    _weaponDir call CBA_fnc_vect2Polar;

private _offset =
    _weapon getVariable [
        "itc_air_gbu15_dir",
        [0,-5]
    ];

private _polarDir =
[
    (_weaponPolar # 1)
        + (_offset # 0),

    (_weaponPolar # 2)
        + (_offset # 1)
];


private _intersect =
[
    getPosASLVisual _weapon,
    _polarDir # 0,
    _polarDir # 1
] call itc_air_common_fnc_intersectAtPolar;


if (!isNil "_intersect") then {

    _weapon setVariable [
        "itc_air_gbu15_track",
        ASLtoAGL _intersect
    ];

    _weapon setVariable [
        "itc_air_gbu15_gstab",
        true
    ];

    _weapon setVariable [
        "itc_air_gbu15_mode",
        "GSTAB"
    ];
};