params ["_display"];
#include "..\..\..\mfdDefines.hpp"

(_display displayCtrl 10200) ctrlShow true;

(_display displayCtrl T1) ctrlSetText "MSG";
(_display displayCtrl T2) ctrlSetText "NAV";
(_display displayCtrl T3) ctrlSetText "DAM";
(_display displayCtrl T4) ctrlSetText "SYS";

invertText(_display, T1);

(_display displayCtrl R5) ctrlSetText "ACK";

private _list = _display displayCtrl 21500;
lbClear _list;