params ["_display"];

_display setVariable [
    "itc_air_ap_choiceMenu",
    ""
];

_display setVariable [
    "itc_air_ap_fn_openChoice",
    compile preprocessFileLineNumbers
        "itc_air_mfd\functions\apps\ap\common\openChoice.sqf"
];

_display setVariable [
    "itc_air_ap_fn_closeChoice",
    compile preprocessFileLineNumbers
        "itc_air_mfd\functions\apps\ap\common\closeChoice.sqf"
];

_display setVariable [
    "itc_air_ap_fn_renderChoice",
    compile preprocessFileLineNumbers
        "itc_air_mfd\functions\apps\ap\common\renderChoice.sqf"
];

"main"