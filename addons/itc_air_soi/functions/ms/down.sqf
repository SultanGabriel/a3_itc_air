params ["_key", "_dir"];

if !(
    "SOI" in
    ((vehicle player) getVariable ["itc_air_systems", []])
) exitWith {
    false
};

_key = toUpper _key;
_dir = toUpper _dir;

private _id = format [
    "%1_%2",
    _key,
    _dir
];

itc_air_soi_switchDownAt set [
    _id,
    time
];

false