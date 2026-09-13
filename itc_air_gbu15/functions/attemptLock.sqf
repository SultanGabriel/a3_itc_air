private _plane =
    vehicle player;

private _weapon =
    _plane getVariable [
        "itc_air_gbu15_activeWeapon",
        objNull
    ];

if (isNull _weapon) exitWith {[]};


private _gstab =
    _weapon getVariable [
        "itc_air_gbu15_gstab",
        false
    ];


/*
 * Require a stabilized point before lock.
 *
 * If currently MAN, stabilize first.
 */

if (!_gstab) then {

    call itc_air_gbu15_fnc_stabilise;

    _gstab =
        _weapon getVariable [
            "itc_air_gbu15_gstab",
            false
        ];
};

if (!_gstab) exitWith {[]};


private _track =
    _weapon getVariable [
        "itc_air_gbu15_track",
        [0,0,0]
    ];

private _target =
    AGLtoASL _track;


/*
 * Scan around seeker center.
 *
 * Same helper used by Maverick.
 */

private _distance =
    (getPosASLVisual _weapon)
    distance
    _target;

private _scan =
[
    _target,
    0.1,
    10,
    _distance
] call itc_air_common_fnc_scanSeekerSquare;


_scan params [
    "_intersectionResults",
    "_intersectionObjects"
];

if (_intersectionObjects isEqualTo []) exitWith {
    []
};


/*
 * First candidate for now,
 * same basic behavior as MAV.
 */

private _targetObject =
    _intersectionObjects # 0;


private _targetIntersections =
[
    _intersectionResults,
    {
        (_this # 2)
        isEqualTo
        _targetObject
    }
] call CBA_fnc_select;


private _count =
    count _targetIntersections;

if (_count == 0) exitWith {
    []
};


private _totalPosition =
    [0,0,0];


{
    _totalPosition =
        _totalPosition
        vectorAdd
        (_x # 0);
}
forEach _targetIntersections;


private _averagePosition =
[
    (_totalPosition # 0) / _count,
    (_totalPosition # 1) / _count,
    (_totalPosition # 2) / _count
];


/*
 * Store the target point relative to the object,
 * so it follows a moving vehicle.
 */

private _targetModelPos =
    _targetObject worldToModel (
        ASLtoAGL _averagePosition
    );


private _lock =
[
    _targetObject,
    _targetModelPos
];


_weapon setVariable [
    "itc_air_gbu15_lock",
    _lock
];

_weapon setVariable [
    "itc_air_gbu15_mode",
    "LOCK"
];


_lock