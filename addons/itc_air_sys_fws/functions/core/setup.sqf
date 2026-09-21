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
// [_id, _occurrence, _acknowledged, _lastAudioCompleted, _audioExpiresAt]
// Meaning: 
//		id             warning ID
//		acknowledged   pilot has ACKed this occurrence
//      occurrence     monotonically increasing aircraft-local identity
//      audioExpiresAt -1 = no audio deadline; never clears the visual
//      lastAudioCompleted -1 = no complete cycle, otherwise CBA_missionTime

_vehicle setVariable [
    "itc_air_fws_active",
    []
];


// Current audio playback state
// -------------------------------------------------------------------------

[_vehicle] call itc_air_fws_fnc_interruptCurrent;


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

// Fuel Monitoring options
[
    _vehicle,
    [
        _vehicle,
        "itc_air_fws_bingoFuel",
        20,
        "BINGO FUEL",
        {},
        "UFC",
        {
            _this >= 0 && _this <= 100
        },
        true
    ]
] call itc_air_common_fnc_addOption;


[
    _vehicle,
    [
        _vehicle,
        "itc_air_fws_lowFuel",
        10,
        "LOW FUEL",
        {},
        "UFC",
        {
            _this >= 0 && _this <= 100
        },
        true
    ]
] call itc_air_common_fnc_addOption;
