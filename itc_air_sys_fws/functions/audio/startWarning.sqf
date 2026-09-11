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
    "_eventTTL",
    "_canPreempt",
    "_acknowledgeMode"
];

if (_audioSequence isEqualTo []) exitWith {
    false
};

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