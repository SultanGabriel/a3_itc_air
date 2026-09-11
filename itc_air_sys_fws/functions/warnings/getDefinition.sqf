params ["_id"];

private _index = itc_air_fws_definitions findIf {
    (_x # 0) isEqualTo _id
};

if (_index < 0) exitWith { [] };

itc_air_fws_definitions # _index
