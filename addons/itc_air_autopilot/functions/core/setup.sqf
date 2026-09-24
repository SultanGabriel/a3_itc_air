params ["_plane"];

if (isNull _plane) exitWith {false};

if (isNil {
    _plane getVariable "itc_air_autopilot_state"
}) then {

    private _apState = createHashMapFromArray [

        ["enabled", false],

        // Pilot-facing mode.
        ["mode", "ALT"],

        // Controller mode:
        // 0 ALT
        // 1 ALT/HDG
        // 2 PATH
        // 3 AGCAS
        ["innerMode", 0],


        // Main AP targets.
        ["target", createHashMapFromArray [
            ["heading", getDir _plane],
            ["altitude", getPosASL _plane # 2]
            ["flightPathAngle", 0],
            ["bank", 0]
        ]],

        // Controller runtime state.
        ["runtime", createHashMapFromArray [
            ["targetVelocityAngle", 0],
            ["targetBank", 0],
            ["pfhId", -1],
            ["lastFrameTime", -1]
        ]]
    ];

    _plane setVariable [
        "itc_air_autopilot_state",
        _apState
    ];
};

true