#define AP_TARGET_MIN_ALTITUDE -1000
#define AP_TARGET_MAX_ALTITUDE 20000

#define AP_TARGET_MIN_FPA -30
#define AP_TARGET_MAX_FPA 30

#define AP_TARGET_MIN_BANK -30
#define AP_TARGET_MAX_BANK 30


params [
    "_variable",
    "_value",
    ["_plane", vehicle player]
];

if !(_value isEqualType 0) exitWith {
    false
};

private _ap = [_plane] call itc_air_autopilot_fnc_ap_getState;

private _target = _ap get "target";

private _success = switch (_variable) do {
    case "heading": {

        _value = _value % 360;

        if (_value < 0) then {
            _value = _value + 360;
        };

        _target set [
            "heading",
            _value
        ];

        true
    };


    case "altitude": {

        if (
            _value < AP_TARGET_MIN_ALTITUDE ||
            {_value > AP_TARGET_MAX_ALTITUDE}
        ) exitWith {
            false
        };

        _target set [
            "altitude",
            _value
        ];

        true
    };


    case "flightPathAngle": {

        if (
            _value < AP_TARGET_MIN_FPA ||
            {_value > AP_TARGET_MAX_FPA}
        ) exitWith {
            false
        };

        _target set [
            "flightPathAngle",
            _value
        ];

        true
    };


    case "bank": {

        if (
            _value < AP_TARGET_MIN_BANK ||
            {_value > AP_TARGET_MAX_BANK}
        ) exitWith {
            false
        };

        _target set [
            "bank",
            _value
        ];

        true
    };


    default {
        false
    };
};


if (!_success) exitWith {

    hint format [
        "Invalid autopilot target: %1 = %2",
        _variable,
        _value
    ];

    false
};

true