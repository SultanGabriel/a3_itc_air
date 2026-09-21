class cfgFunctions
{
    class itc_air_trim
    {
        class functions
        {
            class setup
            {
                file = "itc_air_sys_trim\functions\setup.sqf";
            };

            class perFrame
            {
                file = "itc_air_sys_trim\functions\perFrame.sqf";
            };

            class shutDown
            {
                file = "itc_air_sys_trim\functions\shutDown.sqf";
            };

            class trimUp
            {
                file = "itc_air_sys_trim\functions\pitch\trimUp.sqf";
            };

            class trimDown
            {
                file = "itc_air_sys_trim\functions\pitch\trimDown.sqf";
            };

            class trimReset
            {
                file = "itc_air_sys_trim\functions\pitch\trimReset.sqf";
            };
            class debugConfig
            {
                file = "itc_air_sys_trim\functions\debugConfig.sqf";
            };
        };
    };
};