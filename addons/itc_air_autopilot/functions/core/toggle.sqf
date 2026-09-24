params [
	["_plane", vehicle player]
];

if (!(_plane isKindOf "Plane") || 
	{driver _plane != player}
) exitWith {
	false
};

private _ap =
[_plane]
call itc_air_autopilot_fnc_ap_getState;

private _enabled =
_ap getOrDefault [
	"enabled",
	false
];

[
	_plane,
	!_enabled
] call itc_air_autopilot_fnc_ap_enable