params ["_display", "_name"];

private _current = _display getVariable ["itc_air_ap_choiceMenu", ""];

_display setVariable [
    "itc_air_ap_choiceMenu", [ _name, "" ] select ( _current isEqualTo _name)
];

true
