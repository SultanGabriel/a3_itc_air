params ["_display"];

#include "..\..\mfdDefines.hpp"


// Show dedicated TV page.

(_display displayCtrl 10802) ctrlShow true;


// Create a camera once for this display.

private _cam =
    _display getVariable [
        "itc_air_tv_cam",
        objNull
    ];

if (isNull _cam) then {

    _cam =
        "camera" camCreate [0,0,0];

    _cam camSetFov 0.05;

    _cam cameraEffect [
        "internal",
        "BACK",
        "GBU15_FEED"
    ];

    _cam camCommit 0;

    "GBU15_FEED" setPiPEffect [0];

    _display setVariable [
        "itc_air_tv_cam",
        _cam
    ];
};


// Milestone 1 does not own SOI yet.

_display setVariable [
    "sensor",
    "gbu15"
];

""