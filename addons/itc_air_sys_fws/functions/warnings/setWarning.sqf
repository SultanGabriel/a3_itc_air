params [
    "_vehicle",
    "_id",
    ["_active", true],
    ["_newOccurrence", false]
];

if !(
    _vehicle getVariable [
        "itc_air_fws_initialized",
        false
    ]
) exitWith {
    false
};


private _definition =
    [_id] call itc_air_fws_fnc_getDefinition;

if (_definition isEqualTo []) exitWith {
    false
};

_definition params [
    "_definitionId",
    "_priority",
    "_class",
    "_mode",
    "_audioSequence",
    "_repeatDelay",
    "_audioTTL",
    "_canPreempt",
    "_acknowledgeMode"
];


private _warnings = +(
    _vehicle getVariable [
        "itc_air_fws_active",
        []
    ]
);

private _index = _warnings findIf {
    (_x # 0) isEqualTo _id
};

private _isActive = _index >= 0;


// Clear
// -------------------------------------------------------------------------

if (!_active) exitWith {

    if (_isActive) then {
        _warnings deleteAt _index;

        _vehicle setVariable [
            "itc_air_fws_active",
            _warnings
        ];
    };

    true
};


// Do not add duplicates
// -------------------------------------------------------------------------

if (_isActive && !_newOccurrence) exitWith {
    true
};


// Calculate expiry
// -------------------------------------------------------------------------

private _expiry = -1;

if (_audioTTL > 0) then {
    _expiry = CBA_missionTime + _audioTTL;
};


// Add
// -------------------------------------------------------------------------

// Monotonic per aircraft, including across FWS restarts.
private _occurrence = (_vehicle getVariable ["itc_air_fws_occurrence", 0]) + 1;
_vehicle setVariable ["itc_air_fws_occurrence", _occurrence];

private _warning = [
    _id,
    _occurrence,
    false,
    -1,
    _expiry
];

if (_isActive) then {
    _warnings set [_index, _warning];
} else {
    _warnings pushBack _warning;
};

_vehicle setVariable [
    "itc_air_fws_active",
    _warnings
];

true
