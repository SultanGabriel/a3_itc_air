params [
    "_vehicle",
    "_definition"
];

if (_definition isEqualTo []) exitWith {
    false
};

_definition params [
    "_id",
    "_priority",
    "_class",
    "_mode",
    "_audioSequence",
    "_repeatDelay",
    "_audioTTL",
    "_canPreempt",
    "_acknowledgeMode"
];

if (_audioSequence isEqualTo []) exitWith {
    false
};

private _warnings = _vehicle getVariable ["itc_air_fws_active", []];
private _index = _warnings findIf {(_x # 0) isEqualTo _id};
if (_index < 0) exitWith {false};

_vehicle setVariable ["itc_air_fws_currentOccurrence", (_warnings # _index) # 1];

private _segment = _audioSequence # 0;

_segment params [
    "_sound",
    "_isSpeech"
];

private _source =
    playSound [
        _sound,
        _isSpeech
    ];

_vehicle setVariable [
    "itc_air_fws_currentId",
    _id
];

_vehicle setVariable [
    "itc_air_fws_currentPriority",
    _priority
];

_vehicle setVariable [
    "itc_air_fws_currentSequence",
    _audioSequence
];

_vehicle setVariable [
    "itc_air_fws_currentIndex",
    0
];

_vehicle setVariable [
    "itc_air_fws_currentSource",
    _source
];

true
