params ["_vehicle"];

private _warnings =
    _vehicle getVariable [
        "itc_air_fws_active",
        []
    ];

if (_warnings isEqualTo []) exitWith {
    []
};


// -------------------------------------------------------------------------
// Find highest priority that currently owns the audio channel.
// -------------------------------------------------------------------------

private _highestPriority = -1;

{
    _x params [
        "_id",
        "_acknowledged",
        "_expiry",
        "_lastPlayed"
    ];

    private _definition =
        [_id] call itc_air_fws_fnc_getDefinition;

    if !(_definition isEqualTo []) then {

        _definition params [
            "_definitionId",
            "_priority",
            "_class",
            "_mode",
            "_audioSequence",
            "_repeatDelay",
            "_eventTTL",
            "_canPreempt",
            "_acknowledgeMode"
        ];

        private _silenced =
            _acknowledged &&
            (
                _acknowledgeMode isEqualTo "SILENCE" ||
                _acknowledgeMode isEqualTo "ACKNOWLEDGE"
            );

        private _hasAudio =
            !(_audioSequence isEqualTo []);

        if (
            !_silenced &&
            _hasAudio
        ) then {
            _highestPriority =
                _highestPriority max _priority;
        };
    };

} forEach _warnings;


// -------------------------------------------------------------------------
// Find a playable warning at the highest active priority.
// -------------------------------------------------------------------------

private _candidate = [];

{
    _x params [
        "_id",
        "_acknowledged",
        "_expiry",
        "_lastPlayed"
    ];

    private _definition =
        [_id] call itc_air_fws_fnc_getDefinition;

    if !(_definition isEqualTo []) then {

        _definition params [
            "_definitionId",
            "_priority",
            "_class",
            "_mode",
            "_audioSequence",
            "_repeatDelay",
            "_eventTTL",
            "_canPreempt",
            "_acknowledgeMode"
        ];

        if (_priority isEqualTo _highestPriority
        && !(_audioSequence isEqualTo [])
        ) then {

            private _canPlay = true;

            if (
                _lastPlayed >= 0 &&
                _repeatDelay >= 0
            ) then {
                _canPlay =
                    CBA_missionTime >=
                    (_lastPlayed + _repeatDelay);
            };

            if (_canPlay) exitWith {
                _candidate = _definition;
            };
        };
    };

} forEach _warnings;

_candidate