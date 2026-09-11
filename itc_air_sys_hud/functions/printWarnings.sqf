params ["_plane"];

private _UI =
uiNamespace getVariable [
	"ITC_AIR_HUD_UI",
	displayNull
];

if (isNull _UI) exitWith {};

private _controls = [
	_UI displayCtrl 1010,
	_UI displayCtrl 1011,
	_UI displayCtrl 1012
];

// Hide all warning rows first.

{
	_x ctrlShow false;
	_x ctrlSetText "";
} forEach _controls;

// FWS is optional for the HUD.

if (isNil "itc_air_fws_fnc_getActiveWarnings") exitWith {};

private _warnings =
[_plane]
call itc_air_fws_fnc_getActiveWarnings;

private _shown = 0;

{
	_x params [
		"_id",
		"_class",
		"_priority",
		"_acknowledged"
	];

	private _definition =
	[_id]
	call itc_air_fws_fnc_getDefinition;

	private _acknowledgeMode = "";

	if !(_definition isEqualTo []) then {
		_acknowledgeMode = _definition # 8;
	};

	    /*
		        NONE:
		            Warning cannot be acknowledged.
		
		        SILENCE:
		            Audio stops, but warning stays visible.
		
		        ACKNOWLEDGE:
		            Warning is no longer shown.
	    */

	private _visible =
	!_acknowledged ||
	{
		_acknowledgeMode in [
			"NONE",
			"SILENCE"
		]
	};

	if (
	_visible &&
	{
		_class in ["WARNING", "CAUTION"]
	} &&
	{
		_shown < 3
	}
	) then {
		private _control =
		_controls # _shown;

		private _text =
		[_id]
		call itc_air_fws_fnc_getShorthand;

		private _color =
		if (_class isEqualTo "WARNING") then {
			[1, 0.1, 0.1, 1]
		} else {
			[1, 0.65, 0, 1]
		};

		_control ctrlSetText _text;
		_control ctrlSetTextColor _color;
		_control ctrlShow true;

		_shown = _shown + 1;
	};

	if (_shown >= 3) exitWith {};
} forEach _warnings;