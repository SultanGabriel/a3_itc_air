params ["_display"];
(_display displayCtrl 10400) ctrlShow true;
#include "..\..\..\mfdDefines.hpp"

(_display displayCtrl T2) ctrlSetText "FLT";
(_display displayCtrl T3) ctrlSetText "MSN";
(_display displayCtrl T4) ctrlSetText "MRK";

(_display displayCtrl L4) ctrlSetText "DEL";
if (_display getVariable ["itc_air_ap_returnToPage", false]) then {
  (_display displayCtrl L3) ctrlSetText "GOTO";
};

(_display displayCtrl R3) ctrlSetText "UP";
(_display displayCtrl R34) ctrlSetText "ORD";
(_display displayCtrl R4) ctrlSetText "DN";

invertText(_display,T2);
