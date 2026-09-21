params ["_display"];
#include "..\..\mfdDefines.hpp"
{
  (_display displayCtrl _x) ctrlShow false;
} forEach [10600,61500];

(_display displayCtrl 2200) ctrlShow true;
