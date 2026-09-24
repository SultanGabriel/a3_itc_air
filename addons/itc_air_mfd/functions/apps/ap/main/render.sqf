params ["_display"];

#include "..\..\..\mfdDefines.hpp"

private _plane =
    vehicle player;

private _ap = [_plane] call itc_air_autopilot_fnc_ap_getState;

private _enabled = _ap getOrDefault [
    "enabled",
    false
];

private _mode = _ap getOrDefault [
    "mode",
    "ALT"
];

private _target = _ap getOrDefault [
    "target",
    createHashMap
];

private _heading = _target getOrDefault [
    "heading",
    getDir _plane
];

private _altitude = _target getOrDefault [
    "altitude",
    getPosASL _plane # 2
];

private _menu = _display getVariable [
    "itc_air_ap_choiceMenu",
    ""
];

private _renderChoice = _display getVariable "itc_air_ap_fn_renderChoice";


// -------------------------------------------------------------------------
// NORMAL PAGE
// -------------------------------------------------------------------------

[_display, "", [], "", -1, []] call _renderChoice;


(_display displayCtrl L1) ctrlSetText format [ "AP %1", ["OFF", "ON"] select _enabled ];

(_display displayCtrl L2) ctrlSetText format [ "MODE %1", _mode ];

(_display displayCtrl L3) ctrlSetText format [ "HDG %1", round _heading ];

(_display displayCtrl L4) ctrlSetText format [ "ALT %1", round _altitude ];

(_display displayCtrl L5) ctrlSetText "";


// Right side is empty unless a choice submenu is open.
(_display displayCtrl R1) ctrlSetText "";
(_display displayCtrl R2) ctrlSetText "";
(_display displayCtrl R3) ctrlSetText "";
(_display displayCtrl R4) ctrlSetText "";
(_display displayCtrl R5) ctrlSetText "";


// -------------------------------------------------------------------------
// MODE CHOICE
// -------------------------------------------------------------------------

if (_menu isEqualTo "MODE") then {

    [ _display, "MODE", [ "ALT", "ALT/HDG", "PATH" ], _mode, L2, [] ] call _renderChoice;
};

true