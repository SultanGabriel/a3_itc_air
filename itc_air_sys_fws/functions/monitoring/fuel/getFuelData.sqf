params ["_vehicle"];

// Read-only snapshot: [quantityFraction, burnRatePerMinute, enduranceMinutes,
// sampledAt]. -1 means unavailable; [] means sampling has not been initialized.
+(_vehicle getVariable ["itc_air_fws_fuelData", []])
