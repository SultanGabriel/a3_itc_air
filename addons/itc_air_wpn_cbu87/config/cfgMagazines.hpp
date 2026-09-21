class CfgMagazines
{
    class PylonMissile_1Rnd_Mk82_F;


    class itc_hp_dumb_itc_ammo_cbu87 :
        PylonMissile_1Rnd_Mk82_F
    {
        ammo = "itc_ammo_cbu87";

        displayName = "CBU-87 CEM (itc)";
        displayNameShort = "CBU-87 CEM";
        descriptionShort =
            "Cluster Bomb Unit CEM";

        pylonWeapon = "itc_weap_cbu87";

        mass = 430;

        hardpoints[] =
        {
            "itc_hp_dumb"
        };
    };


    class itc_hp_dumb_itc_ammo_cbu87_sx :
        PylonMissile_1Rnd_Mk82_F
    {
        ammo = "itc_ammo_cbu87_sx_std";

        displayName = "CBU-87SX CEM (itc)";
        displayNameShort = "CBU-87SX";
        descriptionShort =
            "Cluster Bomb Unit CEM (Experimental)";

        pylonWeapon = "itc_weap_cbu87_sx";

        mass = 430;

        hardpoints[] =
        {
            "itc_hp_dumb"
        };
    };


    class itc_hp_dumb_itc_ammo_cbu87_sx_nar :
        itc_hp_dumb_itc_ammo_cbu87_sx
    {
        scope = 1;
        ammo = "itc_ammo_cbu87_sx_nar";
        hardpoints[] = {};
    };


    class itc_hp_dumb_itc_ammo_cbu87_sx_wide :
        itc_hp_dumb_itc_ammo_cbu87_sx
    {
        scope = 1;
        ammo = "itc_ammo_cbu87_sx_wide";
        hardpoints[] = {};
    };
};
