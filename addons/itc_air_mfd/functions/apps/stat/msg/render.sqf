params ["_display"];
#include "..\..\..\mfdDefines.hpp"

private _list = _display displayCtrl 21500;
private _warnings = [vehicle player] call itc_air_fws_fnc_getActiveWarnings;

(_display displayCtrl R5) ctrlSetText "ACK";

lbClear _list;

{
    _x params [
        "_id",
        "_class",
        "_priority",
        "_acknowledged"
    ];

    private _text = (_id splitString "_") joinString " ";
    private _index = _list lbAdd _text;

    private _rightText = if (_acknowledged) then {
        "ACK"
    } else {
        _class
    };

    _list lbSetTextRight [_index, _rightText];

    private _color = switch (true) do {
        case (_acknowledged): {[0.55, 0.55, 0.55, 1]};
        case (_class == "WARNING"): {[1, 0.15, 0.15, 1]};
        case (_class == "CAUTION"): {[1, 0.65, 0, 1]};
        default {[1, 1, 1, 1]};
    };

    _list lbSetColor [_index, _color];

} forEach _warnings;