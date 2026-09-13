params ["_vehicle"];

private _source =
    _vehicle getVariable [
        "itc_air_fws_currentSource",
        objNull
    ];

if !(isNull _source) then {
    deleteVehicle _source;
};

_vehicle setVariable [
    "itc_air_fws_currentId",
    ""
];

_vehicle setVariable ["itc_air_fws_currentOccurrence", -1];

_vehicle setVariable [
    "itc_air_fws_currentPriority",
    -1
];

_vehicle setVariable [
    "itc_air_fws_currentSequence",
    []
];

_vehicle setVariable [
    "itc_air_fws_currentIndex",
    -1
];

_vehicle setVariable [
    "itc_air_fws_currentSource",
    objNull
];

true
