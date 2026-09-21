params ["_vehicle"];

itc_air_agcas_on = false;
itc_air_gcas_on = false;
itc_air_gcas_warn = false;

if (!isNil "itc_air_fws_fnc_setWarning") then {
    {[_vehicle, _x, false] call itc_air_fws_fnc_setWarning} forEach ["PULL_UP", "TERRAIN", "ALTITUDE", "TOO_LOW_GEAR", "SINK_RATE"];
};
