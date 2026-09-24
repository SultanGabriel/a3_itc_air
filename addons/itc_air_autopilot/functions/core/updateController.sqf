//after how much deviation AP will disengage, all values in degrees
#define AP_DISENG_MAX_VELOCITY_ANGLE_DIFF 20
#define AP_DISENG_MAX_BANK_DIFF 40
// #define AP_DISENG_MAX_HDG_DIFF 10

//values used to finetune aggressiveness of autopilot.
//light planes are yanked harder and big ones don't respond too quickly
#define AP_PLANE_WEIGHT_MULT 0.0001
#define AP_PITCH_FORCE_MULT 1
#define AP_BANK_TORQUE_MULT 300
#define AP_YAW_TORQUE_MULT 2500
#define AP_YAW_BOUND 2

//if autopilot applies force below this treshold, we assume that we are on course
//and only deviation is due to plane's flight characteristics, so we will use these values to calibrate
//this is done so plane doesn't drift slowly to one direction
#define AP_VA_CALIBRATION_TRESH 20
#define AP_BANK_CALIBRATION_TRESH 10
#define AP_YAW_CALIBRATION_TRESH 10

params [
    "_plane",
    "_controller"
];


// -------------------------------------------------------------------------
// AP STATE
// -------------------------------------------------------------------------

private _ap = [_plane] call itc_air_autopilot_fnc_ap_getState;

private _target = _ap get "target";


// -------------------------------------------------------------------------
// AP TARGET STATE
// -------------------------------------------------------------------------
//
// target* values are persistent AP setpoints.
// They are not necessarily the commands used by the controller this frame.

private _targetAltitude = _target getOrDefault [
    "altitude",
    getPosASL _plane # 2
];

private _targetHeading = _target getOrDefault [
    "heading",
    getDir _plane
];


// -------------------------------------------------------------------------
// EFFECTIVE CONTROLLER COMMANDS
// -------------------------------------------------------------------------
//
// command* values are the effective values consumed by the low-level
// controller during this update.

private _commandVelocityAngle = _controller getOrDefault [
    "targetVelocityAngle",
    0
];

private _commandBank = _controller getOrDefault [
    "targetBank",
    0
];

private _commandHeading = _targetHeading;
private _commandAltitude = _targetAltitude;


// Pilot-facing mode name.
// Used where ALT/HDG and NAV need to be distinguished.
private _modeName = _ap getOrDefault [
    "mode",
    "ALT"
];

// Low-level controller mode.
// 0 = ALT
// 1 = ALT/HDG or NAV
// 2 = PATH
// 3 = AGCAS
private _innerMode = _ap getOrDefault [
    "innerMode",
    0
];


// -------------------------------------------------------------------------
// MODE COMMAND RESOLUTION
// -------------------------------------------------------------------------
//
// Resolve external command sources before the common controller logic.
// Persistent AP targets are left untouched.

switch (_modeName) do {

    case "NAV": {

        private _guidance = [_plane] call itc_air_autopilot_fnc_ap_getNavGuidance;

        if ( _guidance getOrDefault [ "valid", false ]) then {

            _commandHeading = _guidance getOrDefault [
				"desiredTrack",
				_commandHeading
			];
        };
    };
};


private _enabled = _ap getOrDefault [
    "enabled",
    false
];

private _weightMult = _controller getOrDefault [
	"weightMult",
	getMass _plane * AP_PLANE_WEIGHT_MULT
];


// -------------------------------------------------------------------------
// PAUSE GUARD
// -------------------------------------------------------------------------

private _lastFrameTime = _controller getOrDefault [
    "lastFrameTime",
    -1
];

if (time == _lastFrameTime) exitWith {};

_controller set [
    "lastFrameTime",
    time
];


// -------------------------------------------------------------------------
// AIRCRAFT STATE
// -------------------------------------------------------------------------

private _vX = velocity _plane select 0;
private _vY = velocity _plane select 1;
private _vXY = sqrt (_vX * _vX + _vY * _vY);
private _vZ = velocity _plane select 2;
private _pitchBank = (_plane call BIS_fnc_getPitchBank);

private _velocityAngle = _vZ atan2 _vXY;
private _hdg = getDir _plane;
private _bank = _pitchBank select 1;


// -------------------------------------------------------------------------
// ALTITUDE / FLIGHT-PATH TARGET
// -------------------------------------------------------------------------

private _altDifference = _commandAltitude - (getPosASL _plane select 2);

// If mode is ALT/HDG or NAV, calculate climb rate and velocity angle target.
if (_innerMode == 1) then {

    // m/s, 0.00508fpm = 1m/s
    private _targetClimbRate = -(4000 * 0.00508) max (_altDifference / 6) min (4000 * 0.00508);

    // max pitch -30 ~ 30
    _commandVelocityAngle = -30 max ( asin ( _targetClimbRate / (vectorMagnitude velocity _plane))) min 30;

    _controller set [
        "targetVelocityAngle",
        _commandVelocityAngle
    ];
};


// -------------------------------------------------------------------------
// DISENGAGE MONITOR
// -------------------------------------------------------------------------
// Simple safety checks

// player or plane is dead
if (!alive player || !alive _plane) exitWith {
    [_plane, "DESTROYED"] call itc_air_autopilot_fnc_ap_disengage;
};

// avionics damaged
// FIXME maybe make threshold configurable or check more extensively the aircraft state
private _avionicsDamaged = false;

if (!isNil {_plane getHitPointDamage "HitAvionics"}) then {
    _avionicsDamaged = (_plane getHitPointDamage "HitAvionics") > 0.5;
};

if (_avionicsDamaged) exitWith {
    [_plane, "AVIONICS"] call itc_air_autopilot_fnc_ap_disengage;
};

// Disengage, safety check if it somehow gets disabled.
if (!_enabled) exitWith {
	systemChat "Disengage Sanity Check triggererd";

    private _pfhId =
        _controller getOrDefault [
            "pfhId",
            -1
        ];

    if (_pfhId >= 0) then {

        [_pfhId] call CBA_fnc_removePerFrameHandler;

        _controller set [
            "pfhId",
            -1
        ];
    };
};

// -------------------------------------------------------------------------
// AP DISC unsafe deviations
// -------------------------------------------------------------------------

// speed too low
if (speed _plane < 200) exitWith {
    [_plane, "SPEED"] call itc_air_autopilot_fnc_ap_disengage;
};

// altitude too low
if ((getPos _plane select 2) < 10) exitWith {
    [_plane, "GROUND"] call itc_air_autopilot_fnc_ap_disengage;
};

private _velocityAngleDiseng = (abs(_velocityAngle - _commandVelocityAngle) > AP_DISENG_MAX_VELOCITY_ANGLE_DIFF);

private _hdgRotate = ((_commandHeading - _hdg + 540) mod 360) - 180;

private _hdgDiff = abs _hdgRotate;

private _bankDiseng = abs(_bank - _commandBank) > AP_DISENG_MAX_BANK_DIFF;

// Handle disengagements based on mode and deviation.

// FIXME I think this won't be needed anymoore
// AP Mode AGCAS, aggresive recovery, override safety checks
if (_innerMode == 3) then {
    _velocityAngleDiseng = false;
    _bankDiseng = false;
};

// AP Mode 0
if ( _innerMode == 0 && (_velocityAngleDiseng || _bankDiseng)) exitWith {
    private _reason = [ "BANK_LIMIT", "PITCH_LIMIT" ] select _velocityAngleDiseng;

    [_plane, _reason] call itc_air_autopilot_fnc_ap_disengage;
};

// AP Mode 1
if (_innerMode == 1 && (_velocityAngleDiseng || _bankDiseng)) exitWith {

    private _reason = [ "BANK_LIMIT" , "PITCH_LIMIT" ] select _velocityAngleDiseng;

    [_plane, _reason] call itc_air_autopilot_fnc_ap_disengage;
};

// AP Mode 2
if (
    _innerMode == 2 &&
    (_velocityAngleDiseng || _bankDiseng)
) exitWith {

    private _reason = [ "BANK_LIMIT", "PITCH_LIMIT" ] select _velocityAngleDiseng;

    [_plane, _reason] call itc_air_autopilot_fnc_ap_disengage;
};


// -------------------------------------------------------------------------
// HEADING / BANK COMMAND
// -------------------------------------------------------------------------

_hdgRotate = 0;

// AP Mode 1, ALT/HDG or NAV
if (_innerMode == 1) then {

    _hdgRotate = ((_commandHeading - _hdg + 540) mod 360) - 180;

    _hdgDiff = abs _hdgRotate;

    private _bankTurn = -AP_DISENG_MAX_BANK_DIFF max (_hdgRotate * 2) min AP_DISENG_MAX_BANK_DIFF;

    _commandBank = (_commandBank + _bankTurn)
        max -(_hdgDiff * 4)
        min (_hdgDiff * 4)
        max -AP_DISENG_MAX_BANK_DIFF
        min AP_DISENG_MAX_BANK_DIFF;

    _controller set [
        "targetBank",
        _commandBank
    ];
};


// -------------------------------------------------------------------------
// BANK CONTROL
// -------------------------------------------------------------------------

private _bankCalibrationCounter =
    _controller getOrDefault [
        "bankCalibrationCounter",
        0
    ];

private _bankCalibrationSum =
    _controller getOrDefault [
        "bankCalibrationSum",
        0
    ];

private _bankCalibrationOffset =
    _controller getOrDefault [
        "bankCalibrationOffset",
        0
    ];

// linear relationship between offset and force proved to have most stable results
private _bankTorque =
    (_commandBank - _bank)
    * AP_BANK_TORQUE_MULT
    * _weightMult;

// Calibration
if (abs _bankTorque < AP_BANK_CALIBRATION_TRESH) then {
    _bankCalibrationCounter = _bankCalibrationCounter + 1;
    _bankCalibrationSum = _bankCalibrationSum + _bankTorque;

    if (_bankCalibrationCounter == 100) then {
        _bankCalibrationCounter = 0;
        _bankCalibrationOffset =
            _bankCalibrationOffset +
            _bankCalibrationSum / 100;
        _bankCalibrationSum = 0;
    };
};

// Calculate final torque with calibration offset every frame
_bankTorque = _bankTorque + _bankCalibrationOffset;

// Save calibration values
_controller set [
    "bankCalibrationCounter",
    _bankCalibrationCounter
];

_controller set [
    "bankCalibrationSum",
    _bankCalibrationSum
];

_controller set [
    "bankCalibrationOffset",
    _bankCalibrationOffset
];

// Apply torque to plane
_plane addTorque (
    _plane vectorModelToWorld [
        0,
        -_bankTorque,
        0
    ]
);


// -------------------------------------------------------------------------
// YAW CONTROL
// -------------------------------------------------------------------------

private _yawCalibrationCounter =
    _controller getOrDefault [
        "yawCalibrationCounter",
        0
    ];

private _yawCalibrationSum =
    _controller getOrDefault [
        "yawCalibrationSum",
        0
    ];

private _yawCalibrationOffset =
    _controller getOrDefault [
        "yawCalibrationOffset",
        0
    ];

//YAW
private _yawTorque = 0;

if (_innerMode == 1) then {

    _yawTorque =
        (-AP_YAW_BOUND max _hdgRotate min AP_YAW_BOUND)
        * AP_YAW_TORQUE_MULT
        * _weightMult;

    //Calibration
    if (abs _yawTorque < AP_YAW_CALIBRATION_TRESH) then {
        _yawCalibrationCounter = _yawCalibrationCounter + 1;
        _yawCalibrationSum = _yawCalibrationSum + _yawTorque;

        if (_yawCalibrationCounter == 100) then {
            _yawCalibrationCounter = 0;
            _yawCalibrationOffset =
                _yawCalibrationOffset +
                _yawCalibrationSum / 100;
            _yawCalibrationSum = 0;
        };
    };

    //
    _yawTorque = _yawTorque + _yawCalibrationOffset;

    _plane addTorque (
        _plane vectorModelToWorld [
            0,
            0,
            _yawTorque
        ]
    );

    _controller set [
        "yawCalibrationCounter",
        _yawCalibrationCounter
    ];

    _controller set [
        "yawCalibrationSum",
        _yawCalibrationSum
    ];

    _controller set [
        "yawCalibrationOffset",
        _yawCalibrationOffset
    ];
};


// -------------------------------------------------------------------------
// VELOCITY-ANGLE CONTROL
// -------------------------------------------------------------------------

private _vaCalibrationCounter =
    _controller getOrDefault [
        "vaCalibrationCounter",
        0
    ];

private _vaCalibrationSum =
    _controller getOrDefault [
        "vaCalibrationSum",
        0
    ];

private _vaCalibrationOffset =
    _controller getOrDefault [
        "vaCalibrationOffset",
        0
    ];

//VELOCITY ANGLE
//we use force applied far in front of the nose of the plane so we don't have to worry
//about bank when we want to point nose vertically up
if (_innerMode == 3) then {
    _commandVelocityAngle = 20;

    _controller set [
        "targetVelocityAngle",
        _commandVelocityAngle
    ];
};

private _yawCompensation =
    abs (
        (
            -AP_YAW_BOUND
            max _hdgRotate
            min AP_YAW_BOUND
        )
        * (sin _bank)
        * AP_YAW_TORQUE_MULT
        / 2000
    );

private _pitchForce =
    (
        _commandVelocityAngle -
        _velocityAngle +
        _yawCompensation
    )
    * AP_PITCH_FORCE_MULT
    * _weightMult;

//we want only small samples to not account for large errors
if (abs _pitchForce < AP_VA_CALIBRATION_TRESH) then {
    _vaCalibrationCounter = _vaCalibrationCounter + 1;
    _vaCalibrationSum = _vaCalibrationSum + _pitchForce;

    //below we count average force deficit from last 100 samples, we add it to the offset and reset the counter
    //it is done to prevent situations where plane slowly drifts up or down due to it's flight model
    //(in default behaviour AP would try to apply very small force over a long time while plane slowly looses altitude)
    if (_vaCalibrationCounter == 100) then {
		_vaCalibrationCounter = 0;
		_vaCalibrationOffset = _vaCalibrationOffset + _vaCalibrationSum / 100; _vaCalibrationSum = 0;
    };
};

_pitchForce = _pitchForce + _vaCalibrationOffset;

// Save calibration values
_controller set [
    "vaCalibrationCounter",
    _vaCalibrationCounter
];

_controller set [
    "vaCalibrationSum",
    _vaCalibrationSum
];

_controller set [
    "vaCalibrationOffset",
    _vaCalibrationOffset
];

//we apply the force to point in front of plane's nose
//note that applied force is in world space (not relative to plane)
_plane addForce [
	[0, 0, _pitchForce],
	[0, 500, 0]
];