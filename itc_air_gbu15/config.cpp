class CfgPatches
{
    class itc_air_gbu15
    {
        name = "ITC Air - GBU-15";
        author = "ITC Air";

        units[] = {};
        weapons[] =
        {
            "itc_weap_gbu15"
        };

        requiredVersion = 1.0;

        requiredAddons[] =
        {
            "itc_air",
            "itc_air_ammo"
        };
    };
};


class CfgFunctions
{
    class itc_air_gbu15
    {
        class functions
        {
            class fired
            {
                file = "itc_air_gbu15\functions\fired.sqf";
            };

class slew
{
    file = "itc_air_gbu15\functions\slew.sqf";
};

class keys
{
    file = "itc_air_gbu15\functions\keys.sqf";
};

class stabilise
{
    file = "itc_air_gbu15\functions\stabilise.sqf";
};

class attemptLock
{
    file = "itc_air_gbu15\functions\attemptLock.sqf";
};

class spi
{
    file = "itc_air_gbu15\functions\spi.sqf";
};
        };
    };
};


class CfgAmmo
{
    class Bomb_04_F;

    class itc_ammo_gbu15 : Bomb_04_F
    {
        displayName = "GBU-15";

        /*
         * Milestone 1:
         * No custom guidance yet.
         *
         * ITC's central Fired EH sees this and calls our function.
         */
        ITC_firedEvent = "itc_air_gbu15_fnc_fired";
    };
};


class CfgMagazines
{
    class PylonMissile_1Rnd_Mk82_F;

    class itc_hp_dumb_itc_ammo_gbu15 :
        PylonMissile_1Rnd_Mk82_F
    {
        scope = 2;

        displayName = "GBU-15";
        displayNameShort = "GBU-15";

        ammo = "itc_ammo_gbu15";
        count = 1;

        pylonWeapon = "itc_weap_gbu15";

        /*
         * Temporary.
         * The current ITC A-10 stations expose itc_hp_dumb,
         * so use this for the first test.
         */
        hardpoints[] =
        {
            "itc_hp_dumb"
        };

        /*
         * Approximate store mass for now.
         * We can tune the exact variant later.
         */
        mass = 1110;
    };
};


class CfgWeapons
{
    class Mk82BombLauncher;

    class itc_weap_gbu15 : Mk82BombLauncher
    {
        displayName = "GBU-15";

        magazines[] =
        {
            "itc_hp_dumb_itc_ammo_gbu15"
        };
    };
};
