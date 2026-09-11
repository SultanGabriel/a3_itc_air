class cfgFunctions
{
    class itc_air_fws
    {
        class Core
        {
            class init
            {
                preInit = 1;
                file = "itc_air_sys_fws\functions\core\init.sqf";
            };

            class setup
            {
                file = "itc_air_sys_fws\functions\core\setup.sqf";
            };

            class perFrame
            {
                file = "itc_air_sys_fws\functions\core\perFrame.sqf";
            };

            class perSecond
            {
                file = "itc_air_sys_fws\functions\core\perSecond.sqf";
            };

            class shutDown
            {
                file = "itc_air_sys_fws\functions\core\shutDown.sqf";
            };
        };


        class Warnings
        {
            class definitions
            {
                file = "itc_air_sys_fws\functions\warnings\definitions.sqf";
            };

            class getDefinition
            {
                file = "itc_air_sys_fws\functions\warnings\getDefinition.sqf";
            };

            class setWarning
            {
                file = "itc_air_sys_fws\functions\warnings\setWarning.sqf";
            };

            class acknowledge
            {
                file = "itc_air_sys_fws\functions\warnings\acknowledge.sqf";
            };

            class pruneWarnings
            {
                file = "itc_air_sys_fws\functions\warnings\pruneWarnings.sqf";
            };

            class getActiveWarnings
            {
                file = "itc_air_sys_fws\functions\warnings\getActiveWarnings.sqf";
            };
        };


        class Audio
        {
            class resolve
            {
                file = "itc_air_sys_fws\functions\audio\resolve.sqf";
            };

            class startWarning
            {
                file = "itc_air_sys_fws\functions\audio\startWarning.sqf";
            };

            class finishWarning
            {
                file = "itc_air_sys_fws\functions\audio\finishWarning.sqf";
            };

            class interruptCurrent
            {
                file = "itc_air_sys_fws\functions\audio\interruptCurrent.sqf";
            };
        };


        class FuelMonitoring
        {
            class initFuel
            {
                file = "itc_air_sys_fws\functions\monitoring\fuel\initFuel.sqf";
            };

            class monitorFuel
            {
                file = "itc_air_sys_fws\functions\monitoring\fuel\monitorFuel.sqf";
            };
        };


        class DamageMonitoring
        {
            class initDamage
            {
                file = "itc_air_sys_fws\functions\monitoring\damage\initDamage.sqf";
            };

            class monitorDamage
            {
                file = "itc_air_sys_fws\functions\monitoring\damage\monitorDamage.sqf";
            };
        };
    };
};