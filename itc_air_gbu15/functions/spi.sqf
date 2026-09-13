params ["_plane"];

private _weapon =
    _plane getVariable [
        "itc_air_gbu15_activeWeapon",
        objNull
    ];

if (isNull _weapon) exitWith {
    nil
};


private _lock =
    _weapon getVariable [
        "itc_air_gbu15_lock",
        []
    ];


/*
 * LOCK:
 * return current locked point.
 */

if !(_lock isEqualTo []) exitWith {

    _lock params [
        "_targetObject",
        "_targetModelPos"
    ];

    if (isNull _targetObject) exitWith {
        nil
    };

    _targetObject
        modelToWorldVisualWorld
        _targetModelPos
};


/*
 * GSTAB:
 * return stabilized seeker point.
 */

private _gstab =
    _weapon getVariable [
        "itc_air_gbu15_gstab",
        false
    ];

if (_gstab) exitWith {

    AGLtoASL (
        _weapon getVariable [
            "itc_air_gbu15_track",
            [0,0,0]
        ]
    )
};


nil