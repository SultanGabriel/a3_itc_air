params ["_plane"];

private _UI = uiNamespace getVariable ["ITC_AIR_HUD_UI", displayNull];
if (isNull _UI) exitWith {};

private _show = "AUTOPILOT" in (_plane getVariable ["itc_air_systems", []]);

private _green = [0, 1, 0, 1];
private _gray = [0.6, 0.6, 0.6, 1];

private _apUI = _UI displayCtrl 1030;
private _apMode = _UI displayCtrl 1031;

_apUI ctrlShow _show;
_apMode ctrlShow _show;
if (!_show) exitWith {};

private _x = (safeZoneW / 2) + 0.145;
private _y = (safeZoneH / 2) + 0.005;

private _ap = [_plane] call itc_air_autopilot_fnc_ap_getState;

private _enabled = _ap getOrDefault [
    "enabled",
    false
];

private _mode = _ap getOrDefault [
    "mode",
    "N/A"
];
_apUI ctrlSetText "AP";
_apUI ctrlSetTextColor ([_gray, _green] select _enabled);
_apUI ctrlSetPosition [_x, _y, 0.060, 0.030];
_apUI ctrlCommit 0;

_apMode ctrlSetText _mode;
_apMode ctrlSetTextColor ([_gray, _green] select _enabled);
_apMode ctrlSetPosition [_x, _y + 0.030, 0.060, 0.030];
_apMode ctrlCommit 0;
