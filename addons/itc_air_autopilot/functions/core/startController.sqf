#define AP_MAX_BANK_HOLD 40

params ["_plane"];

private _ap = [_plane] call itc_air_autopilot_fnc_ap_getState;

// Remove any existing controller PFH.
private _oldController = _ap getOrDefault [
    "runtime",
    createHashMap
];

private _oldPfh = _oldController getOrDefault [
    "pfhId",
    -1
];

diag_log format [
    "[ITC AIR AP] START oldPFH=%1 enabled=%2 mode=%3",
    _oldPfh,
    _ap getOrDefault ["enabled", false],
    _ap getOrDefault ["mode", "N/A"]
];

if (_oldPfh >= 0) then {
    [_oldPfh] call CBA_fnc_removePerFrameHandler;
};

// Initial aircraft state.
private _v = velocity _plane;

private _vXY = sqrt ((_v # 0)^2+(_v # 1)^2);

private _velocityAngle = (_v # 2) atan2 _vXY;

private _bank = (_plane call BIS_fnc_getPitchBank) # 1;

// Read the persistent pilot-facing AP targets
private _target = _ap get "target";

// Controller mode used by the low-level AP logic
// 0 = ALT
// 1 = ALT/HDG or NAV
// 2 = PATH
// 3 = AGCAS
private _mode = _ap getOrDefault [
    "innerMode",
    0
];

// Pilot-facing mode is kept separately because multiple public modes may
// share the same low-level controller mode, e.g. ALT/HDG and NAV.
private _modeName = _ap getOrDefault [
    "mode",
    "ALT"
];

// Clamp the bank captured at engagement so ALT cannot begin holding an
// excessive aircraft bank angle.
private _targetBank = _bank max -AP_MAX_BANK_HOLD min AP_MAX_BANK_HOLD;

private _target = _ap get "target";

// Runtime contains effective controller commands and calibration state
// It is not the public AP target interface
private _controller = createHashMapFromArray [
    ["targetVelocityAngle", _velocityAngle],
    ["targetBank", _targetBank],

    ["weightMult", getMass _plane * 0.0001],
    ["lastFrameTime", -1],

    ["vaCalibrationCounter", 0],
    ["vaCalibrationSum", 0],
    ["vaCalibrationOffset", 0],

    ["bankCalibrationCounter", 0],
    ["bankCalibrationSum", 0],
    ["bankCalibrationOffset", 0],

    ["yawCalibrationCounter", 0],
    ["yawCalibrationSum", 0],
    ["yawCalibrationOffset", 0]
];

// Capture mode-specific targets at engagement
// Public targets describe what the pilot/system requested
// runtime stores the effective commands used by the controller
switch (_mode) do {

    // ALT:
    // Hold level flight path and the aircraft's current bank
    case 0: {

        _target set [
            "flightPathAngle",
            0
        ];

        _target set [
            "bank",
            _targetBank
        ];

        _controller set [
            "targetVelocityAngle",
            0
        ];

        _controller set [
            "targetBank",
            _targetBank
        ];
    };


    // ALT/HDG and NAV share the same low-level controller
    case 1: {

        // Capture current altitude when engaging either vertical-hold mode.
        _target set [
            "altitude",
            getPosASL _plane # 2
        ];

        // Only manual ALT/HDG captures aircraft heading.
        // NAV receives its lateral command from external NAV guidance.
        if (_modeName isEqualTo "ALT/HDG") then {
            _target set [
                "heading",
                getDir _plane
            ];
        };

        // Begin from wings-level command. The heading controller will
        // calculate the effective bank command on subsequent updates.
        _controller set [
            "targetVelocityAngle",
            0
        ];

        _controller set [
            "targetBank",
            0
        ];
    };


    // PATH:
    // Capture the current flight-path angle while commanding wings level.
    case 2: {

        _target set [
            "flightPathAngle",
            _velocityAngle
        ];

        _target set [
            "bank",
            0
        ];

        _controller set [
            "targetVelocityAngle",
            _velocityAngle
        ];

        _controller set [
            "targetBank",
            0
        ];
    };


    // AGCAS:
    // Recovery commands are system-owned and must not overwrite pilot targets.
    case 3: {

        _controller set [
            "targetBank",
            0
        ];

        _controller set [
            "targetVelocityAngle",
            20
        ];
    };
};



// Start PFH.
private _pfhId = [{

    _this select 0 params [
        "_plane",
        "_controller"
    ];

    [_plane, _controller] call itc_air_autopilot_fnc_ap_updateController;

}, 0.1, [_plane, _controller]] call CBA_fnc_addPerFrameHandler;


_controller set [
    "pfhId",
    _pfhId
];

_ap set [
    "runtime",
    _controller
];


diag_log format [
    "[ITC AIR AP] START newPFH=%1",
    _pfhId
];


true

