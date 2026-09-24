class CfgFunctions
{
    class itc_air_autopilot
    {
        tag = "itc_air_autopilot";

        class Core
        {
            file = "\itc_air_autopilot\functions\core";

            class setup
            {
                file = "\itc_air_autopilot\functions\core\setup.sqf";
            };

            class ap_getState
            {
                file = "\itc_air_autopilot\functions\core\getState.sqf";
            };

            class ap_toggle
            {
                file = "\itc_air_autopilot\functions\core\toggle.sqf";
            };

            class ap_enable
            {
                file = "\itc_air_autopilot\functions\core\enable.sqf";
            };

            class ap_disengage
            {
                file = "\itc_air_autopilot\functions\core\disengage.sqf";
            };

            class ap_setMode
            {
                file = "\itc_air_autopilot\functions\core\setMode.sqf";
            };

            class ap_cycleMode
            {
                file = "\itc_air_autopilot\functions\core\cycleMode.sqf";
            };

            class ap_setTarget
            {
                file = "\itc_air_autopilot\functions\core\setTarget.sqf";
            };

            class ap_startController
            {
                file = "\itc_air_autopilot\functions\core\startController.sqf";
            };

            class ap_updateController
            {
                file = "\itc_air_autopilot\functions\core\updateController.sqf";
            };
        };

        class Integration
        {
            file = "\itc_air_autopilot\functions\integrations";

            class ap_getNavGuidance
            {
                file = "\itc_air_autopilot\functions\integrations\getNavGuidance.sqf";
            };
        };
    };
};