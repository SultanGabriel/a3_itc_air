params [
    "_display",
    "_btn"
];

#include "..\..\..\mfdDefines.hpp"

private _plane = vehicle player;

private _ap = [_plane] call itc_air_autopilot_fnc_ap_getState;

private _mode = _ap getOrDefault [
    "mode",
    "ALT"
];

private _enabled = _ap getOrDefault [
    "enabled",
    false
];

private _menu = _display getVariable [
    "itc_air_ap_choiceMenu",
    ""
];

private _openChoice = _display getVariable "itc_air_ap_fn_openChoice";

private _closeChoice = _display getVariable "itc_air_ap_fn_closeChoice";


// -------------------------------------------------------------------------
// MODE SUBMENU
// -------------------------------------------------------------------------

if (_menu isEqualTo "MODE") exitWith {

    switch (_btn) do {

        // Toggle the currently open MODE menu closed.
        case "L2": {
            [_display] call _closeChoice;
        };


        // ALT
        case "R1": {

            [ "ALT", _plane ] call itc_air_autopilot_fnc_ap_setMode;

            [_display] call _closeChoice;
        };


        // ALT/HDG
        case "R2": {

            [ "ALT/HDG", _plane ] call itc_air_autopilot_fnc_ap_setMode;

            [_display] call _closeChoice;
        };


        // PATH
        case "R3": {

            [ "PATH", _plane ] call itc_air_autopilot_fnc_ap_setMode;

            [_display] call _closeChoice;
        };
    };

    true
};


// -------------------------------------------------------------------------
// NORMAL PAGE
// -------------------------------------------------------------------------

switch (_btn) do {

    // AP ON/OFF
    case "L1": {
        [_plane] call itc_air_autopilot_fnc_ap_toggle;
    };


    // MODE
    case "L2": {
        [ _display, "MODE" ] call _openChoice;
    };


    // HDG
    case "L3": {

        if ( _enabled && {_mode isEqualTo "ALT/HDG"}) then {
            [ nil, "heading", true, itc_air_autopilot_fnc_ap_setTarget ] call itc_air_ufc_fnc_prepareInput;
        };
    };


    // ALT
    case "L4": {

        if ( _enabled && {_mode isEqualTo "ALT/HDG"}) then {
            [ nil, "altitude", true, itc_air_autopilot_fnc_ap_setTarget ] call itc_air_ufc_fnc_prepareInput;
        };
    };
};

true