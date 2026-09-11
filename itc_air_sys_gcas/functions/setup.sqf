params ["_vehicle"];
itc_air_gcas_time = 0;
[_vehicle, [missionNameSpace,"itc_air_gcas_on",true,"GCAS ON",{},"cycle",[false, true]]] call itc_air_common_fnc_addOption;

if("AGCAS" in (_vehicle getVariable ["itc_air_systems",[]])) then {
  [_vehicle, [missionNameSpace,"itc_air_agcas_on",true,"AGCAS ON",{},"cycle",[false, true]]] call itc_air_common_fnc_addOption;
};

// Low altitude warning threshold.
// Internal value is metres.

[_vehicle, [
    _vehicle,
    "itc_air_gcas_alow",
    250,
    "ALOW M",
    {},
    "UFC",
    {
        _this >= 0 && _this <= 3000
    },
    true
]] call itc_air_common_fnc_addOption;


// State for crossing detection.

_vehicle setVariable [
    "itc_air_gcas_lastAgl",
    getPosATL _vehicle # 2
];

_vehicle setVariable [
    "itc_air_gcas_lowAltArmed",
    true
];