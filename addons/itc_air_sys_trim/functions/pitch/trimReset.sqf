private _plane = vehicle player;

if !(
    "TRIM" in
    (_plane getVariable [
        "itc_air_systems_active",
        []
    ])
) exitWith {};


_plane setVariable [
    "itc_air_trim_pitchTrim",
    0
];