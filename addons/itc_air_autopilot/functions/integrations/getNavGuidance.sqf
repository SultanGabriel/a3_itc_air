params ["_plane"];

private _fallback = createHashMapFromArray [
    ["valid", false],
    ["desiredTrack", getDir _plane],
    ["verticalValid", false]
];

if (isNull _plane) exitWith {
    _fallback
};

// NAV is an optional external system.
// AP only consumes its normalized guidance interface.
if (isNil "itc_air_nav_fnc_getGuidance") exitWith {
    _fallback
};

private _guidance =
    [_plane]
    call itc_air_nav_fnc_getGuidance;

if !(_guidance isEqualType createHashMap) exitWith {
    _fallback
};

_guidance