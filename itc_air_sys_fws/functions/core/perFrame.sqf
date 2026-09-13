params ["_plane"];

if !(
    _plane getVariable [
        "itc_air_fws_initialized",
        false
    ]
) exitWith {};


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

if !(_currentId isEqualTo "") then {
    // Credit a completed cycle before considering a newly arriving preemptor.
    private _source = _plane getVariable ["itc_air_fws_currentSource", objNull];
    private _index = _plane getVariable ["itc_air_fws_currentIndex", -1];
    private _sequence = _plane getVariable ["itc_air_fws_currentSequence", []];
    if (isNull _source && {(_index + 1) >= count _sequence}) then {
        [_plane] call itc_air_fws_fnc_finishWarning;
        _currentId = "";
    };
};

if !(_currentId isEqualTo "") then {
    private _occurrence = _plane getVariable ["itc_air_fws_currentOccurrence", -1];
    private _warnings = _plane getVariable ["itc_air_fws_active", []];
    private _stillActive = (_warnings findIf {
        (_x # 0) isEqualTo _currentId && {(_x # 1) isEqualTo _occurrence}
    }) >= 0;
    private _definition = [_currentId] call itc_air_fws_fnc_getDefinition;
    private _critical = _definition param [9, false];

    // Ordinary speech may finish after ACK/clear. Critical speech must still
    // describe a current hazard. Landing inhibition stops current speech too.
    if (
        (_critical && !_stillActive) ||
        {[_plane, _currentId] call itc_air_fws_fnc_isInhibited}
    ) then {
        [_plane] call itc_air_fws_fnc_interruptCurrent;
        _currentId = "";
    };
};


// -------------------------------------------------------------------------
// Check for higher-priority pre-emption
// -------------------------------------------------------------------------

if !(_currentId isEqualTo "") then {

    private _candidate =
        [_plane, true]
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

            // The reservation may not be due yet; wait silently in that case.
            private _due = [_plane] call itc_air_fws_fnc_resolve;
            if !(_due isEqualTo []) then {
                [_plane, _due] call itc_air_fws_fnc_startWarning;
            };

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
