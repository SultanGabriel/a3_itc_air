params ["_display", "_btn"];
#include "..\..\..\mfdDefines.hpp"
_vehicle = vehicle player;
switch (_btn) do {
  case "R3": {
    [-1] call itc_air_wpt_fnc_reorder;
  };
  case "R4": {
    [1] call itc_air_wpt_fnc_reorder;
  };
  case "L4": {
    [] call itc_air_wpt_fnc_delete;
  };
  case "L3": {
    if (_display getVariable ["itc_air_ap_returnToPage", false]) then {
      ["begin"] call itc_air_autopilot_fnc_goto;
      _display setVariable ["app", "ap"];
    };
  };
};
false
