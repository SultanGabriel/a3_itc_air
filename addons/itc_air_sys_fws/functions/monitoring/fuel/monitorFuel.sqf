params ["_vehicle"];

private _data = [_vehicle] call itc_air_fws_fnc_getFuelData;
if (_data isEqualTo []) exitWith {false};
private _fuel = _data # 0;

// Thresholds and recovery margin are percentage points, not measured fuel data.
private _bingo = (_vehicle getVariable ["itc_air_fws_bingoFuel", 20]) / 100;
private _low = (_vehicle getVariable ["itc_air_fws_lowFuel", 10]) / 100;
private _hysteresis = ((_vehicle getVariable ["itc_air_fws_fuelHysteresis", 1]) max 0.01) / 100;
private _invalidOrder = _low >= _bingo;
if (_invalidOrder && {!(_vehicle getVariable ["itc_air_fws_fuelOrderWarned", false])}) then {
    diag_log "ITC AIR FWS: LOW FUEL must be below BINGO FUEL; check the aircraft fuel thresholds.";
};
_vehicle setVariable ["itc_air_fws_fuelOrderWarned", _invalidOrder];

private _warnings = _vehicle getVariable ["itc_air_fws_active", []];
{
    _x params ["_id", "_threshold"];
    private _active = (_warnings findIf {(_x # 0) isEqualTo _id}) >= 0;
    private _recovery = (_threshold + _hysteresis) min 1;
    // Derive hysteresis from the existing occurrence; no duplicate warning flags.
    private _condition = if (_active) then {
        _fuel < _recovery || {_fuel <= _threshold}
    } else {
        _fuel <= _threshold
    };
    [_vehicle, _id, _condition] call itc_air_fws_fnc_setWarning;
} forEach [["FUEL_BINGO", _bingo], ["FUEL_LOW", _low]];

true
