params ["_vehicle", ["_includeReservation", false]];

private _now = CBA_missionTime;
private _reservedPriority = -1;
private _reservation = [];
private _candidatePriority = -1;
private _candidate = [];

// Derive eligibility from active occurrences; there is no audio queue.
{
    _x params ["_id", "_occurrence", "_acknowledged", "_lastPlayed", "_audioExpiresAt"];
    private _definition = [_id] call itc_air_fws_fnc_getDefinition;

    if !(_definition isEqualTo []) then {
        _definition params [
            "_definitionId", "_priority", "_class", "_mode",
            "_sequence", "_repeatDelay", "_audioTTL", "_canPreempt",
            "_acknowledgeMode", ["_reservesAudio", false]
        ];

        private _silenced = _acknowledged && {_acknowledgeMode != "NONE"};
        private _expired = _audioExpiresAt >= 0 && {_now >= _audioExpiresAt};
        private _delivered = _repeatDelay < 0 && {_lastPlayed >= 0};

        if (
            !_silenced && !_expired && !_delivered &&
            {!(_sequence isEqualTo [])} &&
            {!([_vehicle, _id] call itc_air_fws_fnc_isInhibited)}
        ) then {
            // Critical cadence gaps are reserved, not opportunities for fuel speech.
            if (_reservesAudio && {_priority > _reservedPriority}) then {
                _reservedPriority = _priority;
                _reservation = _definition;
            };

            private _due = _lastPlayed < 0 || {_now >= (_lastPlayed + _repeatDelay)};
            if (_due && {_priority > _candidatePriority}) then {
                _candidate = _definition;
                _candidatePriority = _priority;
            };
        };
    };
} forEach (_vehicle getVariable ["itc_air_fws_active", []]);

// Preemption may need to stop lower speech even during a reserved cadence gap.
if (_candidatePriority < _reservedPriority) exitWith {
    if (_includeReservation) then {_reservation} else {[]}
};
_candidate
