// class CfgWeapons {
//   class Mk82BombLauncher;

//   class itc_weap_cbu87 : Mk82BombLauncher {
//     displayName = "CBU-87 CEM";
//     cursorAim = "bomb";
//     canLock = 0;
//     autoFire = 0;
//     reloadTime = 0.01;
//     magazineReloadTime = 0.01;
//     magazines[] = {"itc_hp_dumb_itc_ammo_cbu87"};
//   };
// };

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
};