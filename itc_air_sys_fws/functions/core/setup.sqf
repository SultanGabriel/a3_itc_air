params ["_vehicle"];

/*
    Initialize FWS runtime state for this aircraft.
*/

_vehicle setVariable [
    "itc_air_fws_initialized",
    true
];


// Warning state
// -------------------------------------------------------------------------

// Entry:
// [_id, _acknowledged, _expiry, _lastPlayed]
// Meaning: 
//		id             warning ID
//		acknowledged   pilot has ACKed this occurrence
//		expiry         -1 = producer-owned, otherwise absolute expiry time
//		lastPlayed     -1 = never played, otherwise CBA_missionTime

_vehicle setVariable [
    "itc_air_fws_active",
    []
];


// Current audio playback state
// -------------------------------------------------------------------------

_vehicle setVariable [
    "itc_air_fws_currentId",
    ""
];

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


// Internal monitors
// -------------------------------------------------------------------------

[_vehicle] call itc_air_fws_fnc_initFuel;
[_vehicle] call itc_air_fws_fnc_initDamage;


// MFD option
// -------------------------------------------------------------------------

[
    _vehicle,
    [
        missionNamespace,
        "itc_air_fws_auralOn",
        true,
        "FWS AUDIO",
        {},
        "cycle",
        [false, true]
    ]
] call itc_air_common_fnc_addOption;