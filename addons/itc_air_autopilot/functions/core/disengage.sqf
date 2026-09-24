params [
    "_plane",
    ["_reason", "MANUAL"]
];

private _ap = [_plane] call itc_air_autopilot_fnc_ap_getState;

private _wasEnabled = _ap getOrDefault [
	"enabled",
	false
];

private _controller = _ap getOrDefault [
	"runtime",
	createHashMap
];

// Mark disabled immediately.
_ap set [
    "enabled",
    false
];

// Always clean up any controller PFH.
private _handler = _controller getOrDefault [
	"pfhId",
	-1
];

if (_handler >= 0) then {
    [_handler] call CBA_fnc_removePerFrameHandler;

    _controller set [
        "pfhId",
        -1
    ];
};

// Already disengaged: cleanup only.
// Do not replay warnings / sounds / hints.
if (!_wasEnabled) exitWith {
    false
};

diag_log format [
    "[ITC AIR AP] DISENGAGE plane=%1 reason=%2 enabled=%3 mode=%4 speed=%5 altATL=%6",
    _plane,
    _reason,
    _wasEnabled,
    _ap getOrDefault ["mode", "N/A"],
    speed _plane,
    getPosATL _plane # 2
];

systemChat format [
    "AP DISENGAGE: %1",
    _reason
];

// params [
// 	"_plane",
// 	["_reason", "MANUAL"]
// ];

// private _ap =
// [_plane]
// call itc_air_autopilot_fnc_ap_getState;

// private _controller =
// _ap get "runtime";

// // STATE
// _ap set [
// 	"enabled",
// 	false
// ];

// // CONTROLLER CLEANUP
// private _handler = _controller getOrDefault [
// 	"pfhId",
// 	-1
// ];

// if (_handler >= 0) then {
// 	[_handler]
// 	call CBA_fnc_removePerFrameHandler;

// 	_controller set [
// 		"pfhId",
// 		-1
// 	];
// };

// PILOT FEEDBACK
private _message = switch (_reason) do {
	case "MANUAL": {
		"Autopilot turned off"
	};

	case "AVIONICS": {
		"Autopilot off - Damaged"
	};

	case "SPEED": {
		"Autopilot off - Speed"
	};

	case "GROUND": {
		"Autopilot off - Ground"
	};

	case "PITCH_LIMIT": {
		"Autopilot off - Pitch limit"
	};

	case "BANK_LIMIT": {
		"Autopilot off - Bank limit"
	};

	case "HEADING_LIMIT": {
		"Autopilot off - Heading limit"
	};

	case "DESTROYED": {
		""
	};

	default {
		"Autopilot disengaged"
	};
};

if (_reason != "DESTROYED") then {
	hint _message;
};

// DISCONNECT CALLOUT

playSound "Click";
playSound "Click";
playSound "Click";

if (!isNil "itc_air_fws_fnc_setWarning") then {
	[
		_plane,
		"AP_DISC",
		true,
		true
	] call itc_air_fws_fnc_setWarning;
};

true