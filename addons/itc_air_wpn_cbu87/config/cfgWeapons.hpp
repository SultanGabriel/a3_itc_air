class CfgWeapons
{
    class Mk82BombLauncher;


    class itc_weap_cbu87 : Mk82BombLauncher
    {
        displayName = "CBU-87 CEM";

        cursorAim = "bomb";
        canLock = 0;
        showEmpty = 1;

        magazines[] =
        {
            "itc_hp_dumb_itc_ammo_cbu87"
        };
    };


    class itc_weap_cbu87_sx : Mk82BombLauncher
    {
        displayName = "CBU-87SX CEM";

        cursorAim = "bomb";
        canLock = 0;
        showEmpty = 1;

        magazines[] =
        {
            "itc_hp_dumb_itc_ammo_cbu87_sx",
            "itc_hp_dumb_itc_ammo_cbu87_sx_nar",
            "itc_hp_dumb_itc_ammo_cbu87_sx_wide"
        };
    };
};
