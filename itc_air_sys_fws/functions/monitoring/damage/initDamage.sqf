params ["_vehicle"];

/*
    Initialize FWS damage-monitor state.

    No complete damage model is stored here.
    monitorDamage.sqf will inspect current Arma hit-point damage
    and create warning states from relevant conditions.
*/

true