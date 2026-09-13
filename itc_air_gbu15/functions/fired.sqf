params [
    "_plane",
    "_weapon",
    "",
    "",
    "_ammo",
    "",
    "_projectile",
    "_gunner"
];

if (isNull _projectile) exitWith {};


/*
 * Only one actively controlled GBU-15 for now.
 */

_plane setVariable [
    "itc_air_gbu15_activeWeapon",
    _projectile
];


/*
 * Source aircraft.
 */

_projectile setVariable [
    "itc_air_gbu15_source",
    _plane
];


/*
 * Seeker state.
 *
 * DIR:
 * [azimuth offset, elevation offset]
 * relative to current bomb flight direction.
 */

_projectile setVariable [
    "itc_air_gbu15_dir",
    [0, -5]
];

_projectile setVariable [
    "itc_air_gbu15_gstab",
    false
];

_projectile setVariable [
    "itc_air_gbu15_track",
    [0,0,0]
];

_projectile setVariable [
    "itc_air_gbu15_lock",
    []
];


/*
 * Seeker handling.
 */

_projectile setVariable [
    "itc_air_gbu15_slewSpeed",
    5
];

_projectile setVariable [
    "itc_air_gbu15_fov",
    0.1
];

_projectile setVariable [
    "itc_air_gbu15_mode",
    "MAN"
];