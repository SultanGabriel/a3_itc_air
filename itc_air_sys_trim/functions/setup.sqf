params ["_vehicle"];

private _config =
itc_air_seat_config >> "trim";

// Cache aircraft-specific pitch trim configuration.

_vehicle setVariable [
	"itc_air_trim_pitchConfig",
	[
		getNumber (_config >> "maxNoseUpTrim"),
		getNumber (_config >> "maxNoseDownTrim"),

		getNumber (_config >> "trimRateUp"),
		getNumber (_config >> "trimRateDown"),

		getNumber (_config >> "pitchAuthority"),
		getNumber (_config >> "referenceSpeed"),

		getNumber (_config >> "minimumEffectSpeed"),
		getNumber (_config >> "maximumSpeedFactor")
	]
];

// do not overwrite an existing trim position.

if (
isNil {
	_vehicle getVariable
	"itc_air_trim_pitchTrim"
}
) then {
	_vehicle setVariable [
		"itc_air_trim_pitchTrim",
		0
	];
};

// Input state belongs to the local pilot.

itc_air_trim_pitchUpHeld = false;
itc_air_trim_pitchDownHeld = false;