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


private _target =
    [0,0,0];


/*
 * LOCK
 */

if !(_lock isEqualTo []) then {

    _lock params [
        "_targetObject",
        "_targetModelPos"
    ];

    if (!isNull _targetObject) then {

        _target =
            ASLtoAGL (
                _targetObject
                modelToWorldVisualWorld
                _targetModelPos
            );
    };
};


/*
 * GSTAB
 */

if (
    _target isEqualTo [0,0,0] &&
    _gstab
) then {

    _target =
        _weapon getVariable [
            "itc_air_gbu15_track",
            [0,0,0]
        ];
};


/*
 * MAN
 */

if (_target isEqualTo [0,0,0]) then {

    private _polar =
        _weaponDir
        call CBA_fnc_vect2Polar;

    private _offset =
        _weapon getVariable [
            "itc_air_gbu15_dir",
            [0,-5]
        ];

    private _dir =
    [
        1,

        (_polar # 1)
            + (_offset # 0),

        (_polar # 2)
            + (_offset # 1)

    ] call CBA_fnc_polar2vect;


    _target =
        _camPos vectorAdd (
            _dir vectorMultiply 2000
        );
};


private _fov =
    _weapon getVariable [
        "itc_air_gbu15_fov",
        0.1
    ];

_cam camSetFov _fov;

_cam camSetPos _camPos;
_cam camSetTarget _target;
_cam camCommit 0;