params ["_display"];
#include "..\..\..\mfdDefines.hpp"
_vehicle = vehicle player;
//(_display displayCtrl 211000) ctrlSetText (_vehicle getVariable "stpt_name");


(_display displayCtrl L4) ctrlSetText format["%1M",round ((getPosASL _vehicle) # 2)];
(_display displayCtrl L5) ctrlSetText format["%1FT",round (3.28084 * ((getPosASL _vehicle) # 2))];

_northDir = 360 - (getDir _vehicle);
(_display displayCtrl 211201) ctrlSetAngle [_northDir, 0.5, 0.5];
(_display displayCtrl 211000) ctrlSetText format["HDG %1", round (getDir _vehicle)];
(_display displayCtrl 211001) ctrlSetText format["%1 KTS", round ((speed _vehicle) * 0.539957)];


if(itc_air_wpt_name != "N/A") then {
  _dir = _vehicle getRelDir itc_air_wpt_pos;
  (_display displayCtrl 211202) ctrlSetAngle [_dir, 0.5, 0.5];

  private _dist = round ((_vehicle distance itc_air_wpt_pos) / 1000);
  private _cts = round (_vehicle getDir itc_air_wpt_pos);

  (_display displayCtrl 211005) ctrlSetText format["%1 / %2km",str _cts, str _dist];
  (_display displayCtrl 211006) ctrlSetText itc_air_wpt_tof;
  (_display displayCtrl 211007) ctrlSetText itc_air_wpt_name;
};

if(itc_air_wpt_tcn_on) then {
  _this call test_fnc_tcn;
  [_display] call itc_air_wpt_fnc_drawTACAN;
} else {
  (_display displayCtrl 211002) ctrlSetText "";
  (_display displayCtrl 211003) ctrlSetText "";
  (_display displayCtrl 211004) ctrlSetText "";
};

private _ap = [_vehicle] call itc_air_autopilot_fnc_ap_getState;

private _apEnabled = _ap getOrDefault [
    "enabled",
    false
];

private _apMode = _ap getOrDefault [
    "mode",
    "ALT"
];

private _apTarget = _ap getOrDefault [
    "target",
    createHashMap
];

private _targetHdg = _apTarget getOrDefault [
    "heading",
    getDir _vehicle
];

if ( _apEnabled &&
    {_apMode isEqualTo "ALT/HDG"} &&
    { "AUTOPILOT" in ( _vehicle getVariable [ "itc_air_systems", [] ]) }
) then {
    (_display displayCtrl 211205) ctrlSetAngle [ _targetHdg - getDir _vehicle, 0.5, 0.5 ];
    (_display displayCtrl 211205) ctrlShow true;
} else {
    (_display displayCtrl 211205) ctrlShow false;
};


(_display displayCtrl R4) ctrlSetText format["%1%2",round ((fuel _vehicle) * 100),"%"];
(_display displayCtrl R5) ctrlSetText format["%1 min",_vehicle getVariable "playtime"];

if ( ITC_AIR_UFC_CTXT_PAGE isEqualTo "STATNAV") then {

    private _ap = [_vehicle] call itc_air_autopilot_fnc_ap_getState;

    private _target = _ap getOrDefault [
            "target",
            createHashMap
        ];

    private _targetAlt = _target getOrDefault [
            "altitude",
            getPosASL _vehicle # 2
        ];

    private _targetHdg = _target getOrDefault [
            "heading",
            getDir _vehicle
        ];

    ITC_AIR_UFC_CTXT_COLUMNS_TXT set [
        5,
        str round _targetAlt
    ];

    ITC_AIR_UFC_CTXT_COLUMNS_TXT set [
        1,
        str round _targetHdg
    ];
};