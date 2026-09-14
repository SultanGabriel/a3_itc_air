params ["_plane", "", "", "", "", "", "_projectile", ""];

if(isNull _projectile || {!local _projectile}) exitWith {};

if(_projectile getVariable ["itc_air_cbu87_hofHandler", false]) exitWith {};

_projectile setVariable ["itc_air_cbu87_hofHandler", true];

private _hofM = _plane getVariable ["prof_hof", 50];

[{
  (_this # 0) params ["_projectile","_hofM"];
  private _handle = _this # 1;

  if(isNull _projectile || {!local _projectile}) exitWith {
    [_handle] call CBA_fnc_removePerFrameHandler;
  };

  private _shotInfo = getShotInfo _projectile;
  if(count _shotInfo > 6 && {_shotInfo # 6}) exitWith {
    [_handle] call CBA_fnc_removePerFrameHandler;
  };

  if((velocity _projectile) # 2 >= 0) exitWith {};

  if((getPos _projectile) # 2 <= _hofM) then {
    triggerAmmo _projectile;
    [_handle] call CBA_fnc_removePerFrameHandler;
  };
}, 0, [_projectile,_hofM]] call CBA_fnc_addPerFrameHandler;
