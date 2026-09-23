params ["_key", "_dir"];

if !("SOI" in
((vehicle player) getVariable ["itc_air_systems", []])) exitWith {
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
itc_air_soi_switchdownAt getOrDefault [
    _id,
    -1
];

itc_air_soi_switchdownAt set [
    _id,
    -1
];

if (_downAt < 0) exitWith {
    false
};

private _long =
time > (_downAt + 0.2);

// Existing global TMS behavior.

switch (_key) do {
    case "TMS": {
        switch (_dir) do {
            case "DOWN": {
                if (_long) exitWith {
                    private _target =
                    ([] call itc_air_wpt_fnc_getCurrent) # 2;
                    
                    ITC_AIR_MAVERICK_GSTAB = true;
                    ITC_AIR_MAVERICK_TRACK =
                    ASLToATL _target;
                    
                    [
                        _target,
                        vehicle player
                    ] call itc_air_tgp_fnc_target;
                };
            };
        };
    };
};

// Dispatch to current SOI.

private _functionname = format [
    "itc_air_%1_fnc_keys",
    ITC_AIR_SOI
];

private _function =
missionNamespace getVariable _functionname;

if (!isNil "_function") then {
    [
        _key,
        _dir,
        _long
    ] call _function;
};

false