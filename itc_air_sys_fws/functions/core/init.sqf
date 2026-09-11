/*
    Global initialization for ITC AIR FWS.

    This runs once when the addon is initialized.
    Aircraft-specific state is initialized in setup.sqf.
*/

itc_air_fws_definitions =
    call itc_air_fws_fnc_definitions;

if (isNil "itc_air_fws_auralOn") then {
    itc_air_fws_auralOn = true;
};


// Add keybind for EICAS ACK
[
    "ITC Air",
    "itc_air_fws_ack",
    "FWS ACK",
    {
        private _vehicle = vehicle player;

        if (
            _vehicle getVariable [
                "itc_air_fws_initialized",
                false
            ]
        ) then {
            [_vehicle]
                call itc_air_fws_fnc_acknowledge;
        };

        false
    },
    "",
    []
] call CBA_fnc_addKeybind;