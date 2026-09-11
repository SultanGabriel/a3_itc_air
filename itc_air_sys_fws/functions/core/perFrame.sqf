params ["_plane"];

if !(
    _plane getVariable [
        "itc_air_fws_initialized",
        false
    ]
) exitWith {};


// -------------------------------------------------------------------------
// Remove expired temporary warnings
// -------------------------------------------------------------------------

// FIXME bring back if i want to support temporary warnings that practically expire and remoove themselves
// FIXME this i will want to highly test, think if it's really needed and maybe stop doing it 
[_plane]
    call itc_air_fws_fnc_pruneWarnings;


// -------------------------------------------------------------------------
// Audio disabled
// -------------------------------------------------------------------------

if (!itc_air_fws_auralOn) exitWith {

    private _currentId =
        _plane getVariable [
            "itc_air_fws_currentId",
            ""
        ];

    if !(_currentId isEqualTo "") then {
        [_plane]
            call itc_air_fws_fnc_interruptCurrent;
    };
};


// -------------------------------------------------------------------------
// Current playback
// -------------------------------------------------------------------------

private _currentId =
    _plane getVariable [
        "itc_air_fws_currentId",
        ""
    ];


// -------------------------------------------------------------------------
// Check for higher-priority pre-emption
// -------------------------------------------------------------------------

if !(_currentId isEqualTo "") then {

    private _candidate =
        [_plane]
            call itc_air_fws_fnc_resolve;

    if !(_candidate isEqualTo []) then {

        private _candidatePriority =
            _candidate # 1;

        private _canPreempt =
            _candidate # 7;

        private _currentPriority =
            _plane getVariable [
                "itc_air_fws_currentPriority",
                -1
            ];
        private _candidateId =
            _candidate # 0;

        if (
        !(_candidateId isEqualTo _currentId) &&
        _canPreempt &&
        _candidatePriority > _currentPriority
        ) then {

            [_plane]
                call itc_air_fws_fnc_interruptCurrent;

            [_plane, _candidate]
                call itc_air_fws_fnc_startWarning;

            _currentId =
                _plane getVariable [
                    "itc_air_fws_currentId",
                    ""
                ];
        };
    };
};


// -------------------------------------------------------------------------
// Continue current audio sequence
// -------------------------------------------------------------------------

if !(_currentId isEqualTo "") exitWith {

    private _source =
        _plane getVariable [
            "itc_air_fws_currentSource",
            objNull
        ];

    // Sound is still playing.
    if !(isNull _source) exitWith {};


    private _sequence =
        _plane getVariable [
            "itc_air_fws_currentSequence",
            []
        ];

    private _index =
        _plane getVariable [
            "itc_air_fws_currentIndex",
            -1
        ];

    private _nextIndex = _index + 1;


    // -------------------------------------------------------------
    // Sequence complete
    // -------------------------------------------------------------

    if (_nextIndex >= count _sequence) exitWith {

        [_plane]
            call itc_air_fws_fnc_finishWarning;
    };


    // -------------------------------------------------------------
    // Play next segment
    // -------------------------------------------------------------

    private _segment =
        _sequence # _nextIndex;

    _segment params [
        "_sound",
        "_isSpeech"
    ];

    private _nextSource =
        playSound [
            _sound,
            _isSpeech
        ];

    _plane setVariable [
        "itc_air_fws_currentIndex",
        _nextIndex
    ];

    _plane setVariable [
        "itc_air_fws_currentSource",
        _nextSource
    ];
};


// -------------------------------------------------------------------------
// Nothing playing: resolve next warning
// -------------------------------------------------------------------------

private _candidate =
    [_plane]
        call itc_air_fws_fnc_resolve;

if !(_candidate isEqualTo []) then {

    [_plane, _candidate]
        call itc_air_fws_fnc_startWarning;
};