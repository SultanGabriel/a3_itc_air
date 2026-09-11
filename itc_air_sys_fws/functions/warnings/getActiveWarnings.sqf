params ["_vehicle"];

if !(
    _vehicle getVariable [
        "itc_air_fws_initialized",
        false
    ]
) exitWith {
    []
};


// Remove expired EVENT warnings first.

[_vehicle] call itc_air_fws_fnc_pruneWarnings;


private _warnings =
    _vehicle getVariable [
        "itc_air_fws_active",
        []
    ];

private _result = [];


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
            "_class"
        ];

        _result pushBack [
            _id,
            _class,
            _priority,
            _acknowledged
        ];
    };

} forEach _warnings;


// Highest priority first.

_result = [
    _result,
    [],
    {
        -(_x # 2)
    },
    "ASCEND"
] call BIS_fnc_sortBy;


_result