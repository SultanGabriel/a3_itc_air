class CfgPatches {
  class itc_air_wpn_cbu87 {
    name = "ITC Aircraft CBU-87 CEM";
    author = "ITC Air";

    units[] = {};

    weapons[] =
    {
        "itc_weap_cbu87",
        "itc_weap_cbu87_sx"
    };

    requiredVersion = 1.0;

    requiredAddons[] = {
        "A3_Weapons_F_Orange",
        "itc_air",
        "itc_air_ammo",
        "itc_air_dsms"
    };
  
  };
};

#include "config\cfgFunctions.hpp"
#include "config\cfgAmmo.hpp"
#include "config\cfgMagazines.hpp"
#include "config\cfgWeapons.hpp"
