params ["_display", "_menu", "_options", "_selected", "_activeButton", "_escapeButtons"];
#include "..\..\..\mfdDefines.hpp"

private _normalColor = [0, 1, 0, 1];
private _normalBackground = [0, 0, 0, 0];
private _disabledColor = [0.35, 0.35, 0.35, 1];
private _leftButtons = [L1, L2, L3, L4, L5];
private _rightButtons = [R1, R2, R3, R4, R5];
private _allButtons = _leftButtons + _rightButtons;

{
    (_display displayCtrl _x) ctrlSetTextColor _normalColor;
    (_display displayCtrl _x) ctrlSetBackgroundColor _normalBackground;
} forEach _allButtons;

if (_menu == "") exitWith {true};

{
    (_display displayCtrl _x) ctrlSetTextColor _disabledColor;
} forEach _allButtons;

if (_activeButton isEqualType 0 && {_activeButton >= 0}) then {
    (_display displayCtrl _activeButton) ctrlSetTextColor _normalColor;
};

{
    (_display displayCtrl _x) ctrlSetTextColor _normalColor;
} forEach _escapeButtons;

for "_i" from 0 to 4 do {
    private _control = _display displayCtrl (_rightButtons # _i);
    if (_i < count _options) then {
        private _option = _options # _i;
        private _marker = [" ", "*"] select ( _option isEqualTo _selected);

        _control ctrlSetTextColor _normalColor;
        _control ctrlSetText format["%1 %2", _marker, _option];
    } else {
        _control ctrlSetText "";
    };
};

true
