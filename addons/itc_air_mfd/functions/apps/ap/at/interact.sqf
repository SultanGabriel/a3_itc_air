params ["_display", "_btn"];
#include "..\..\..\mfdDefines.hpp"

private _menu = _display getVariable ["itc_air_ap_choiceMenu", ""];
private _openChoice = _display getVariable "itc_air_ap_fn_openChoice";
private _closeChoice = _display getVariable "itc_air_ap_fn_closeChoice";
private _selectChoice = _display getVariable "itc_air_ap_fn_selectChoice";

if (_menu != "") exitWith {
    switch (_btn) do {
        case "L2": {[_display, "AT_MODE"] call _openChoice;};
        case "L5": {[_display] call _closeChoice;};
        case "R1": {
            [_display, "itc_air_ap_mock_atMode", "SPD"] call _selectChoice;
            systemChat "AP MFD MOCK: AT mode integration point";
        };
    };
    false
};

switch (_btn) do {
    case "L1": {
        systemChat "AP MFD MOCK: AT enable integration point";
    };
    case "L2": {
        [_display, "AT_MODE"] call _openChoice;
    };
    case "L5": {
        _display setVariable ["page", "main"];
    };
    case "R1": {
        systemChat "AP MFD MOCK: AT target speed integration point";
    };
};
false
