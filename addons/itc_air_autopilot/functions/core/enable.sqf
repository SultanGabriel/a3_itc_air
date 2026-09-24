params [
    "_plane",
    ["_enabled", true]
];

private _ap = [_plane] call itc_air_autopilot_fnc_ap_getState;


if (!_enabled) exitWith {
    [_plane, "MANUAL"] call itc_air_autopilot_fnc_ap_disengage;

    true
};


if (_ap getOrDefault [
        "enabled",
        false
    ]
) exitWith {
    true
};


private _mode = _ap getOrDefault [
    "mode",
    "ALT"
];


if (_mode == "NAV") then {

    private _guidance = [_plane] call itc_air_autopilot_fnc_ap_getNavGuidance;

    if !(_guidance getOrDefault [
        "valid",
        false
    ]) exitWith {
        hint "NAV guidance unavailable";

        false
    };
};

private _target = _ap get "target";

_target set [
    "heading",
    getDir _plane
];

_target set [
    "altitude",
    getPosASL _plane # 2
];



// Enable Autopilot 
_ap set [
    "enabled",
    true
];

[_plane]
    call itc_air_autopilot_fnc_ap_startController;

true