params [
    "_key",
    "_dir"
];

private _vehicle = vehicle player;

if (isnil "itc_air_soi_switchdownAt") exitwith {
    false
};

_key = toUpper _key;
_dir = toUpper _dir;

private _id = format [
    "%1_%2",
    _key,
    _dir
];

private _downAt =
itc_air_soi_switchdownAt
getordefault [
    _id,
    -1
];

// Mark this switch as released.

itc_air_soi_switchdownAt set [
    _id,
    -1
];

if (_downAt < 0) exitwith {
    false
};

if !(
"SOI" in
(_vehicle getVariable [
    "itc_air_systems",
    []
])
) exitwith {
    false
};

private _long = (diag_ticktime - _downAt) > 0.2;

// Global SOI-level HOTAS behavior.

if (
_key == "TMS" &&
_dir == "doWN" &&
_long
) exitwith {
    private _current =
    [] call itc_air_wpt_fnc_getCurrent;
    
    if (!(_current isEqualtype []) ||
    {
        count _current < 3
    }
    ) exitwith {
        false
    };
    
    private _target =
    _current # 2;
    
    ITC_AIR_MAVERICK_GSTAB = true;
    ITC_AIR_MAVERICK_TRACK =
    ASLtoATL _target;
    
    [
        _target,
        _vehicle
    ] call itc_air_tgp_fnc_target;
    
    false
};

// Pass the event to the current SOI.

private _functionname = format [
    "itc_air_%1_fnc_keys",
    ITC_AIR_SOI
];

private _function =
missionnamespace
getVariable _functionname;

if (!isnil "_function") then {
    [
        _key,
        _dir,
        _long
    ] call _function;
};

false