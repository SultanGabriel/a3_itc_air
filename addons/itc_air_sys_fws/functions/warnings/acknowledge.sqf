params [
    ["_vehicle", vehicle player]
];

if (
    isNull _vehicle ||
    _vehicle isEqualTo player
) exitWith {
    false
};

if !(
    _vehicle getVariable [
        "itc_air_fws_initialized",
        false
    ]
) exitWith {
    false
};

private _warnings = +(
    _vehicle getVariable [
        "itc_air_fws_active",
        []
    ]
);


// Work backwards because EVENT warnings can be deleted.
// Deleting from the end avoids index changes for entries not yet processed.

for "_i" from ((count _warnings) - 1) to 0 step -1 do {

    private _warning = _warnings # _i;

    _warning params [
        "_id",
        "_occurrence",
        "_acknowledged",
        "_lastPlayed",
        "_audioExpiresAt"
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
            "_audioTTL",
            "_canPreempt",
            "_acknowledgeMode"
        ];

        switch (_acknowledgeMode) do {

            case "SILENCE": {

                _warning set [
                    2,
                    true
                ];

                _warnings set [
                    _i,
                    _warning
                ];
            };


            case "ACKNOWLEDGE": {

                if (_mode isEqualTo "EVENT") then {

                    // The event is complete from the pilot's point of view.
                    _warnings deleteAt _i;

                } else {

                    // Keep the underlying STATE warning.
                    // Audio and display logic can hide acknowledged warnings.

                    _warning set [
                        2,
                        true
                    ];

                    _warnings set [
                        _i,
                        _warning
                    ];
                };
            };


            case "NONE": {
                // Critical warning. ACK has no effect.
            };
        };
    };
};


_vehicle setVariable [
    "itc_air_fws_active",
    _warnings
];
