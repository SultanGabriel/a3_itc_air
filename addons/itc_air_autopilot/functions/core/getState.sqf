params ["_plane"];

if (isNull _plane) exitWith {
    createHashMap
};

if (isNil {
    _plane getVariable "itc_air_autopilot_state"
}) then {
    systemChat "Sanity check: getState initialized ap state obj";

    [_plane] call itc_air_autopilot_fnc_setup;
};

_plane getVariable [
    "itc_air_autopilot_state",
    createHashMap
]