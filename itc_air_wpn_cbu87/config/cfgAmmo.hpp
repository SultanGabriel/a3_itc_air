class CfgAmmo {
  class BombCluster_01_Ammo_F;
  class Mo_cluster_Bomb_01_F;

  class itc_ammo_cbu87 : BombCluster_01_Ammo_F
  {
      displayName = "CBU-87 CEM";

      weaponType = "bomb";

      submunitionAmmo = "itc_ammo_blu97";

      submunitionConeType[] =
      {
          "poissondisc",
          32
      };

      deleteParentWhenTriggered = 1;

      ITC_clusterFuze = "PROX";
      ITC_clusterFuzeName = "FZU-39/B";

      ITC_clusterHOF[] =
      {
          25,
          50,
          100
      };

      ITC_clusterDefaultHOF = 50;

      ITC_firedEvent =
          "itc_air_cbu87_fnc_fired";
  };

  class itc_ammo_blu97 : Mo_cluster_Bomb_01_F {
    displayName = "BLU-97";
  };
};
