class CfgAmmo
{
    class BombCluster_01_Ammo_F;
    class Mo_cluster_Bomb_01_F;


    // ============================================================
    // BLU-97 PAYLOAD
    // ============================================================

    class itc_ammo_blu97 : Mo_cluster_Bomb_01_F
    {
        displayName = "BLU-97";

        // Stronger than vanilla, but still reasonable.
        hit = 90;
        indirectHit = 22;
        indirectHitRange = 7.5;
        caliber = 40;
    };


    class itc_ammo_blu97_sx : itc_ammo_blu97
    {
        displayName = "BLU-97 SX";

        hit = 110;
        indirectHit = 30;
        indirectHitRange = 9;
        caliber = 45;
    };


    // ============================================================
    // COMMON CBU-87 DISPENSER BASE
    //
    // IMPORTANT:
    // Do NOT override:
    // - simulation
    // - triggerDistance
    // - triggerTime
    // - triggerOnImpact
    //
    // The inherited Arma cluster configuration is known to work.
    // ============================================================

    class itc_ammo_cbu87_base : BombCluster_01_Ammo_F
    {
        weaponType = "bomb";

        deleteParentWhenTriggered = 1;

        ITC_clusterFuze = "PROX";
        ITC_clusterFuzeName = "FZU-39/B";
        ITC_profileOptionsFunction =
            "itc_air_cbu87_fnc_getProfileOptions";

        ITC_firedEvent =
            "itc_air_cbu87_fnc_fired";
    };


    // ============================================================
    // NORMAL CBU-87
    // ============================================================

    class itc_ammo_cbu87 : itc_ammo_cbu87_base
    {
        displayName = "CBU-87 CEM";

        submunitionAmmo =
            "itc_ammo_blu97";

        submunitionConeType[] =
        {
            "poissondisc",
            64
        };

        submunitionConeAngle = 10;

        ITC_clusterHOF[] =
        {
            100,
            250,
            400
        };

        ITC_clusterDefaultHOF = 100;
    };


    // ============================================================
    // COMMON CBU-87SX CONFIGURATION
    // ============================================================

    class itc_ammo_cbu87_sx_base : itc_ammo_cbu87_base
    {
        displayName = "CBU-87SX CEM";

        submunitionAmmo =
            "itc_ammo_blu97_sx";

        submunitionConeType[] =
        {
            "poissondisc",
            96
        };

        ITC_clusterHOFMin = 50;
        ITC_clusterHOFMax = 700;
        ITC_clusterDefaultHOF = 150;

        ITC_clusterPatternDefault = "STD";
        ITC_clusterPattern[] =
        {
            "NAR",
            "itc_hp_dumb_itc_ammo_cbu87_sx_nar",
            "STD",
            "itc_hp_dumb_itc_ammo_cbu87_sx",
            "WIDE",
            "itc_hp_dumb_itc_ammo_cbu87_sx_wide"
        };
    };


    class itc_ammo_cbu87_sx_nar : itc_ammo_cbu87_sx_base
    {
        submunitionConeAngle = 6;
    };


    class itc_ammo_cbu87_sx_std : itc_ammo_cbu87_sx_base
    {
        submunitionConeAngle = 10;
    };


    class itc_ammo_cbu87_sx_wide : itc_ammo_cbu87_sx_base
    {
        submunitionConeAngle = 14;
    };

};
