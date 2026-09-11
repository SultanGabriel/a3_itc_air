params ["_plane"];
if(getPos _plane # 2 < 1 || !itc_air_gcas_on) exitWith {itc_air_gcas_warn = false;};


private _collide = [_plane, 1.5] call itc_air_gcas_fnc_checkCollide;
private _terrainWarning = [_plane, 5.5] call itc_air_gcas_fnc_checkCollide;

if(_collide) then {
  itc_air_gcas_warn = true;
  itc_air_gcas_time = CBA_missionTime;

  // Call FWS to set warning

  if(!(_plane getVariable ["itc_air_gearState",true]) && (ITC_AP_mode != 3 || !ITC_AP_isEnabled) && itc_air_agcas_on) then {
    systemChat "AGCAS RECOVER";
    ITC_AP_isEnabled = false;
    _plane spawn {
      sleep 0.05;
      ITC_AP_isEnabled = true;
      [_this, 3] call itc_air_autopilot_fnc_autopilot;
    };
  };
};

private _lastCollide = _plane getVariable ["itc_air_gcas_lastCollide", false];
private _lastTerrain = _plane getVariable ["itc_air_gcas_lastTerrain", false];

if (!(isNil "itc_air_fws_fnc_setWarning")) then
{
    if (_collide != _lastCollide) then
    {
        _plane setVariable ["itc_air_gcas_lastCollide", _collide];
        [_plane, "PULL_UP", _collide] call itc_air_fws_fnc_setWarning;
    };

    if (_terrainWarning != _lastTerrain) then
    {
        _plane setVariable ["itc_air_gcas_lastTerrain", _terrainWarning];
        [_plane, "TERRAIN", _terrainWarning] call itc_air_fws_fnc_setWarning;
    };
};


// ------------------------------------------------------------------
// LOW ALTITUDE
// ------------------------------------------------------------------

private _agl =
    getPosATL _plane # 2;

private _alow =
    _plane getVariable [
        "itc_air_gcas_alow",
        250
    ];

private _lastAgl =
    _plane getVariable [
        "itc_air_gcas_lastAgl",
        _agl
    ];

private _lowAltArmed =
    _plane getVariable [
        "itc_air_gcas_lowAltArmed",
        true
    ];

private _gearDown =
    _plane getVariable [
        "itc_air_gearState",
        false
    ];


// Rearm only after climbing clearly above the threshold.
// 30 m prevents repeated warnings when flying around the boundary.

if (
    !_lowAltArmed &&
    _agl > (_alow + 30)
) then {

    _lowAltArmed = true;

    _plane setVariable [
        "itc_air_gcas_lowAltArmed",
        true
    ];
};


// Trigger only while crossing downward.

if (
    _lowAltArmed &&
    !_gearDown &&
    _lastAgl > _alow &&
    _agl <= _alow
) then {

    if (!(isNil "itc_air_fws_fnc_setWarning")) then {
        [_plane, "LOW_ALTITUDE", true]
            call itc_air_fws_fnc_setWarning;
    };

    _plane setVariable [
        "itc_air_gcas_lowAltArmed",
        false
    ];
};


_plane setVariable [
    "itc_air_gcas_lastAgl",
    _agl
];