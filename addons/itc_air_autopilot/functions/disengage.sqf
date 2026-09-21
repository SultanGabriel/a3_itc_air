params ["_plane"];

// A live controller represents an engagement. Use its existing handle rather
// than another armed flag; the MFD may already have set ITC_AP_isEnabled false.
private _handler = missionNamespace getVariable ["itc_air_autopilot_pfhId", -1];
ITC_AP_isEnabled = false;
if (_handler < 0) exitWith {false};

[_handler] call CBA_fnc_removePerFrameHandler;
itc_air_autopilot_pfhId = nil;

if (!isNil "itc_air_fws_fnc_setWarning") then {
    [_plane, "AP_DISC", true, true] call itc_air_fws_fnc_setWarning;
};

true
