params ["_display"];
#include "..\..\..\mfdDefines.hpp"

private _mode = _display getVariable ["itc_air_ap_mock_atMode", "SPD"];
private _target = _display getVariable ["itc_air_ap_mock_atTarget", 450];
private _menu = _display getVariable ["itc_air_ap_choiceMenu", ""];
private _renderChoice = _display getVariable "itc_air_ap_fn_renderChoice";

[_display, "", [], "", -1, []] call _renderChoice;

(_display displayCtrl L1) ctrlSetText "AT OFF";
(_display displayCtrl L2) ctrlSetText format["MODE %1", _mode];
(_display displayCtrl L5) ctrlSetText "BACK";
(_display displayCtrl R1) ctrlSetText format["TARGET %1", _target];
(_display displayCtrl B1) ctrlSetText "";
(_display displayCtrl B2) ctrlSetText "";
(_display displayCtrl B3) ctrlSetText "";
(_display displayCtrl B4) ctrlSetText "";

(_display displayCtrl 43000) ctrlSetText "AUTOTHROTTLE";
(_display displayCtrl 43001) ctrlSetText "AT OFF / MOCK ONLY";
(_display displayCtrl 43002) ctrlSetText format["MODE %1", _mode];
(_display displayCtrl 43003) ctrlSetText format["TARGET %1", _target];
(_display displayCtrl 43004) ctrlSetText "UI MOCK / NO AT CONTROL";

if (_menu == "AT_MODE") then {
    [_display, "AT_MODE", ["SPD"], _mode, L2, [L5]] call _renderChoice;
};
