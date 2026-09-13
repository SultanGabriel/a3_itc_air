params ["_vehicle"];

private _fuel = fuel _vehicle;
private _now = CBA_missionTime;
private _history = _vehicle getVariable ["itc_air_fws_fuelSample", [_fuel, _fuel, _now]];
_history params ["_lastFuel", "_sampleFuel", "_sampleTime"];
private _data = _vehicle getVariable ["itc_air_fws_fuelData", [_fuel, -1, -1, _now]];
private _burnRate = _data # 1;

// Refuelling invalidates the consumption window, including partial refills
// that do not reach the quantity at the start of that window.
if (_fuel > _lastFuel || {!isEngineOn _vehicle}) then {
    _sampleFuel = _fuel;
    _sampleTime = _now;
    _burnRate = -1;
} else {
    private _elapsed = _now - _sampleTime;
    if (_elapsed >= 15) then {
        _burnRate = (((_sampleFuel - _fuel) max 0) / _elapsed) * 60;
        _sampleFuel = _fuel;
        _sampleTime = _now;
    };
};

private _endurance = if (_burnRate > 0.0001) then {_fuel / _burnRate} else {-1};
private _snapshot = [_fuel, _burnRate, _endurance, _now];
_vehicle setVariable ["itc_air_fws_fuelSample", [_fuel, _sampleFuel, _sampleTime]];
_vehicle setVariable ["itc_air_fws_fuelData", _snapshot];

+_snapshot
