params [
    "_key",
    "_dir"
];

private _vehicle = vehicle player;

if !(
    "SOI" in
    (_vehicle getVariable [
        "itc_air_systems",
        []
    ])
) exitWith {
    false
};


if (
    isNil "itc_air_soi_switchDownAt"
) then {
    itc_air_soi_switchDownAt =
        createHashMap;
};


private _id = format [
    "%1_%2",
    toUpper _key,
    toUpper _dir
];

itc_air_soi_switchDownAt set [
    _id,
    diag_tickTime
];


false