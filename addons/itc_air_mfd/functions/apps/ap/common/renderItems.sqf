#include "\itc_air_mfd\functions\mfdDefines.hpp"

params [
    "_display",
    "_buttons",
    "_items" 
]
// [
//     "_label",
//     "_value",
//     "_enabled" = true,
//     "_owned" = false,
//     "_action" = ""
// ]
// [
//     "HDG",          // label
//     "083",          // value
//     true,           // enabled / interactable
//     false,          // owned / externally controlled
//     "HDG_INPUT"     // action id
// ]

//   ["HDG", str round _hdg, false, false, ""],
//     ["ALT", str round _alt, true, false, "ALT_INPUT"],
//     ["", "", true, false, "CONFIRM"]

private _normalColor = [0, 1, 0, 1];
private _normalBackground = [0, 0, 0, 0];
private _disabledColor = [0.35, 0.35, 0.35, 1];
// private _leftButtons = [L1, L2, L3, L4, L5];
// private _rightButtons = [R1, R2, R3, R4, R5];
// private _allButtons = _leftButtons + _rightButtons;


// Reset all buttons
{
    private _control = _display displayCtrl _x;
    
    _control ctrlSetTextColor _normalColor;
    _control ctrlSetBackgroundColor _normalBackground;
    _control ctrlSetText "";

} forEach _buttons;

for "_i" from 0 to ((count _buttons)-1) do {
    // if the index is greater than the number of items
    if (_i >= count _items) then {
        continue;
    }

    private _item = _items # _i;

    _item params [
        "_label",
        "_value",
        ["_enabled" = true],
        ["_owned" = false],
        ["_action" = ""]
    ];

    private _button = _buttons # _i;
    private _control = _display displayCtrl _button;
    private _ownedMarker = if (_owned) then {" *"} else {""};
    private _text = if (value == "") then {
        format ["%1%2", _label, _ownedMarker]
    } else {
        format ["%1 %2%3", _label, _value, _ownedMarker]
    }

    _control ctrlSetText _text;
}

true