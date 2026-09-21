params ["_plane", "_frameTime"];


// Only the machine that owns the aircraft should apply physics.

if (!local _plane) exitWith {};


private _pitchConfig =
    _plane getVariable [
        "itc_air_trim_pitchConfig",
        []
    ];

if (_pitchConfig isEqualTo []) exitWith {};


_pitchConfig params [
    "_maxNoseUpTrim",
    "_maxNoseDownTrim",

    "_trimRateUp",
    "_trimRateDown",

    "_pitchAuthority",
    "_referenceSpeed",

    "_minimumEffectSpeed",
    "_maximumSpeedFactor"
];



// Update trim position.
private _pitchTrim =
    _plane getVariable [
        "itc_air_trim_pitchTrim",
        0
    ];


// Opposing trim inputs cancel each other.
if (
    itc_air_trim_pitchUpHeld !=
    itc_air_trim_pitchDownHeld
) then {

    if (itc_air_trim_pitchUpHeld) then {
        _pitchTrim =
            _pitchTrim +
            (_trimRateUp * _frameTime);
    };

    if (itc_air_trim_pitchDownHeld) then {
        _pitchTrim =
            _pitchTrim -
            (_trimRateDown * _frameTime);
    };
};


_pitchTrim =
    (_pitchTrim max -_maxNoseDownTrim)
        min _maxNoseUpTrim;


_plane setVariable [
    "itc_air_trim_pitchTrim",
    _pitchTrim
];



// Apply aerodynamic pitch trim effect.
if (_pitchTrim == 0) exitWith {};


private _velocity =
    velocityModelSpace _plane;

private _forwardSpeed =
    abs (_velocity # 1);


if (
    _forwardSpeed <
    _minimumEffectSpeed
) exitWith {};


private _speedFactor =
    (_forwardSpeed / _referenceSpeed) ^ 2;

_speedFactor =
    (_speedFactor max 0)
        min _maximumSpeedFactor;


private _pitchTorque =
    _pitchTrim *
    _pitchAuthority *
    _speedFactor;


_plane addTorque (
    _plane vectorModelToWorld [
        -_pitchTorque,
        0,
        0
    ]
);