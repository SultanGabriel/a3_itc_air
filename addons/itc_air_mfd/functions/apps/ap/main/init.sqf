params ["_display"];

#include "..\..\..\mfdDefines.hpp"

_display setVariable [
    "itc_air_ap_choiceMenu",
    ""
];

// Clear left side.
(_display displayCtrl L1) ctrlSetText "";
(_display displayCtrl L2) ctrlSetText "";
(_display displayCtrl L3) ctrlSetText "";
(_display displayCtrl L4) ctrlSetText "";
(_display displayCtrl L5) ctrlSetText "";

// Clear right side.
(_display displayCtrl R1) ctrlSetText "";
(_display displayCtrl R2) ctrlSetText "";
(_display displayCtrl R3) ctrlSetText "";
(_display displayCtrl R4) ctrlSetText "";
(_display displayCtrl R5) ctrlSetText "";

// AP currently has no subpages.
(_display displayCtrl T1) ctrlSetText "";
(_display displayCtrl T2) ctrlSetText "";
(_display displayCtrl T3) ctrlSetText "";
(_display displayCtrl T4) ctrlSetText "";
(_display displayCtrl T5) ctrlSetText "";

true