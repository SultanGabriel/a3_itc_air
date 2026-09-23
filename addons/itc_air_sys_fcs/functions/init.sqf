itc_air_fcs_releaseKeyDown = false;

itc_air_fcs_ccrp_frame = 0;
itc_air_fcs_ccip_frame = 0;
itc_air_ccrp_lastPickleHold = time;
itc_air_ccrp_PickleRelease = false;
itc_air_ccrp_lastDist = 100;
itc_air_fcs_ccrpOn = false;

itc_air_fcs_ccip_impactTime = 0;


itc_air_fcs_hasFIR = isClass (configFile >> "cfgPatches" >> "FIR_AirWeaponSystem_US");
if(itc_air_fcs_hasFIR) then {
  ["itc_air_fcs_overrideITGT", "CHECKBOX", "Override FIR I-TGT from SPI", "ITC Air", [false]] call CBA_Settings_fnc_init;
} else {
  itc_air_fcs_overrideITGT = false;
};
