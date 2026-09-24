params [
    "_mode",
    ["_plane", vehicle player]
];

private _ap = [_plane] call itc_air_autopilot_fnc_ap_getState;

private _innerMode = switch (_mode) do {
    case "ALT":     {0};
    case "ALT/HDG": {1};
    case "PATH":    {2};
    case "NAV":     {1};
    case "AGCAS":   {3};

    default {-1};
};

if (_innerMode < 0) exitWith {
    false
};

private _oldMode = _ap getOrDefault [
    "mode",
    "ALT"
];

if (_oldMode isEqualTo _mode) exitWith {
    true
};


// NAV requires valid external guidance before it can become active.
if (_mode isEqualTo "NAV") then {

    private _guidance = [_plane] call itc_air_autopilot_fnc_ap_getNavGuidance;

    if !( _guidance getOrDefault [ "valid", false ]) exitWith {
        hint "NAV guidance unavailable";

        false
    };
};


// Store the selected public and low-level controller modes.
_ap set [
    "mode",
    _mode
];

_ap set [
    "innerMode",
    _innerMode
];


// If AP is not currently engaged, only remember the selected mode.
// The controller will be initialized when AP is next enabled.
if !( _ap getOrDefault [ "enabled", false ]) exitWith {
    true
};


// Reinitialize the active controller for the newly selected mode.
// startController handles target capture, runtime initialization,
// old PFH cleanup and creation of the new controller PFH.
[_plane] call itc_air_autopilot_fnc_ap_startController;

true