params [
    ["_plane", vehicle player]
];

private _ap = [_plane] call itc_air_autopilot_fnc_ap_getState;

private _modes = [
    "ALT",
    "ALT/HDG",
    "PATH"
];

private _current = _ap getOrDefault [
    "mode",
    "ALT"
];

private _index = _modes find _current;

if (_index < 0) then {
    _index = 0;
};

private _nextMode = _modes # ((_index + 1) % count _modes);

[_nextMode, _plane] call itc_air_autopilot_fnc_ap_setMode;

hint format [
    "Autopilot mode switched to %1",
    _nextMode
];

true