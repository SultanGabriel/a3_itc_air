// Runtime trim configuration editor for testing.
// Pass [["name", value], ...] to change values.
// Returns the complete current runtime configuration.

params [
    "_plane",
    ["_changes", []]
];


private _config =
    _plane getVariable [
        "itc_air_trim_pitchConfig",
        []
    ];

if (_config isEqualTo []) exitWith {
    []
};


_config params [
    "_maxNoseUpTrim",
    "_maxNoseDownTrim",

    "_trimRateUp",
    "_trimRateDown",

    "_pitchAuthority",
    "_referenceSpeed",

    "_minimumEffectSpeed",
    "_maximumSpeedFactor"
];


// Apply requested runtime changes.

{
    _x params [
        "_name",
        "_value"
    ];

    switch (_name) do {

        case "maxNoseUpTrim": {
            _maxNoseUpTrim = _value;
        };

        case "maxNoseDownTrim": {
            _maxNoseDownTrim = _value;
        };

        case "trimRateUp": {
            _trimRateUp = _value;
        };

        case "trimRateDown": {
            _trimRateDown = _value;
        };

        case "pitchAuthority": {
            _pitchAuthority = _value;
        };

        case "referenceSpeed": {
            _referenceSpeed = _value;
        };

        case "minimumEffectSpeed": {
            _minimumEffectSpeed = _value;
        };

        case "maximumSpeedFactor": {
            _maximumSpeedFactor = _value;
        };
    };

} forEach _changes;


// Store updated runtime configuration.

private _newConfig = [
    _maxNoseUpTrim,
    _maxNoseDownTrim,

    _trimRateUp,
    _trimRateDown,

    _pitchAuthority,
    _referenceSpeed,

    _minimumEffectSpeed,
    _maximumSpeedFactor
];

_plane setVariable [
    "itc_air_trim_pitchConfig",
    _newConfig
];


// Return readable current configuration.

[
    ["maxNoseUpTrim", _maxNoseUpTrim],
    ["maxNoseDownTrim", _maxNoseDownTrim],

    ["trimRateUp", _trimRateUp],
    ["trimRateDown", _trimRateDown],

    ["pitchAuthority", _pitchAuthority],
    ["referenceSpeed", _referenceSpeed],

    ["minimumEffectSpeed", _minimumEffectSpeed],
    ["maximumSpeedFactor", _maximumSpeedFactor]
]