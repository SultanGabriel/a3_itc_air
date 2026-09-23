class UserActionGroups
{
    class ITC_AIR
    {
        name = "ITC AIR";
        isAddon = 1;

        group[] =
        {
            // FWS
            "ITC_AIR_FWS_ACK",

            // Pitch Trim
            "ITC_AIR_TRIM_PITCH_UP",
            "ITC_AIR_TRIM_PITCH_DOWN",
            "ITC_AIR_TRIM_PITCH_RESET",

            // SOI
            "ITC_AIR_SOI_CYCLE",

            "ITC_AIR_SOI_SLEW_UP",
            "ITC_AIR_SOI_SLEW_DOWN",
            "ITC_AIR_SOI_SLEW_LEFT",
            "ITC_AIR_SOI_SLEW_RIGHT",

            // TMS
            "ITC_AIR_SOI_TMS_UP",
            "ITC_AIR_SOI_TMS_DOWN",
            "ITC_AIR_SOI_TMS_LEFT",
            "ITC_AIR_SOI_TMS_RIGHT",

            // DMS
            "ITC_AIR_SOI_DMS_UP",
            "ITC_AIR_SOI_DMS_DOWN",
            "ITC_AIR_SOI_DMS_LEFT",
            "ITC_AIR_SOI_DMS_RIGHT",

            // MFD
            "ITC_AIR_MFD_CURSOR_OPEN",
            "ITC_AIR_MFD_CURSOR_CLOSE",
            "ITC_AIR_MFD_TOGGLE_LEFT",
            "ITC_AIR_MFD_TOGGLE_RIGHT",
            "ITC_AIR_MFD_OPEN_TGP",
            
            // FCS
            "ITC_AIR_FCS_RELEASE",

            // WPT
            "ITC_AIR_WPT_NEXT",
            "ITC_AIR_WPT_PREV",

            // Autopilot
            "ITC_AIR_AP_TOGGLE",
            "ITC_AIR_AP_MODE",
        };
    };
};


// FIXME migrate all controls slowly to here
class CfgUserActions
{
    // ------------------------------------------------------------------------
    // System SOI
    // ------------------------------------------------------------------------
    // SOI Cycle
    class ITC_AIR_SOI_CYCLE
    {
        displayName = "SOI Cycle";
        tooltip = "Cycle the active Sensor of Interest";

        onActivate = "if (!isNil 'itc_air_soi_fnc_cycle') then { call itc_air_soi_fnc_cycle; };";
    };

    // SOI Slew
    // | `ITC_AIR_SOI_CYCLE`         | Cycle SOI           |
    // | `ITC_AIR_SOI_UP`            | Slew up             |
    // | `ITC_AIR_SOI_DOWN`          | Slew down           |
    // | `ITC_AIR_SOI_LEFT`          | Slew left           |
    // | `ITC_AIR_SOI_RIGHT`         | Slew right          |

    class ITC_AIR_SOI_SLEW_UP
    {
        displayName = "SOI Slew Up";
        tooltip = "Slew the active Sensor of Interest up";

        onActivate = "if (!isNil 'itc_air_soi_fnc_slewInput') then { ['UP', true] call itc_air_soi_fnc_slewInput; };";
        onDeactivate = "if (!isNil 'itc_air_soi_fnc_slewInput') then { ['UP', false] call itc_air_soi_fnc_slewInput; };";
    };


    class ITC_AIR_SOI_SLEW_DOWN
    {
        displayName = "SOI Slew Down";
        tooltip = "Slew the active Sensor of Interest down";

        onActivate = "if (!isNil 'itc_air_soi_fnc_slewInput') then { ['DOWN', true] call itc_air_soi_fnc_slewInput; };";
        onDeactivate = "if (!isNil 'itc_air_soi_fnc_slewInput') then { ['DOWN', false] call itc_air_soi_fnc_slewInput; };";
    };


    class ITC_AIR_SOI_SLEW_LEFT
    {
        displayName = "SOI Slew Left";
        tooltip = "Slew the active Sensor of Interest left";

        onActivate = "if (!isNil 'itc_air_soi_fnc_slewInput') then { ['LEFT', true] call itc_air_soi_fnc_slewInput; };";
        onDeactivate = "if (!isNil 'itc_air_soi_fnc_slewInput') then { ['LEFT', false] call itc_air_soi_fnc_slewInput; };";
    };


    class ITC_AIR_SOI_SLEW_RIGHT
    {
        displayName = "SOI Slew Right";
        tooltip = "Slew the active Sensor of Interest right";

        onActivate = "if (!isNil 'itc_air_soi_fnc_slewInput') then { ['RIGHT', true] call itc_air_soi_fnc_slewInput; };";
        onDeactivate = "if (!isNil 'itc_air_soi_fnc_slewInput') then { ['RIGHT', false] call itc_air_soi_fnc_slewInput; };";
    };

    // TMS 

    // | `ITC_AIR_SOI_TMS_UP`        | TMS up              |
    // | `ITC_AIR_SOI_TMS_DOWN`      | TMS down            |
    // | `ITC_AIR_SOI_TMS_LEFT`      | TMS left            |
    // | `ITC_AIR_SOI_TMS_RIGHT`     | TMS right           |

    class ITC_AIR_SOI_TMS_UP
    {
        displayName = "TMS Up";
        tooltip = "Send TMS Up to the active Sensor of Interest";

        onActivate = "if (!isNil 'itc_air_soi_fnc_ms_down') then { ['TMS', 'UP'] call itc_air_soi_fnc_ms_down; };";
        onDeactivate = "if (!isNil 'itc_air_soi_fnc_ms_up') then { ['TMS', 'UP'] call itc_air_soi_fnc_ms_up; };";
    };


    class ITC_AIR_SOI_TMS_DOWN
    {
        displayName = "TMS Down";
        tooltip = "Send TMS Down to the active Sensor of Interest";

        onActivate = "if (!isNil 'itc_air_soi_fnc_ms_down') then { ['TMS', 'DOWN'] call itc_air_soi_fnc_ms_down; };";
        onDeactivate = "if (!isNil 'itc_air_soi_fnc_ms_up') then { ['TMS', 'DOWN'] call itc_air_soi_fnc_ms_up; };";
    };


    class ITC_AIR_SOI_TMS_LEFT
    {
        displayName = "TMS Left";
        tooltip = "Send TMS Left to the active Sensor of Interest";

        onActivate = "if (!isNil 'itc_air_soi_fnc_ms_down') then { ['TMS', 'LEFT'] call itc_air_soi_fnc_ms_down; };";
        onDeactivate = "if (!isNil 'itc_air_soi_fnc_ms_up') then { ['TMS', 'LEFT'] call itc_air_soi_fnc_ms_up; };";
    };


    class ITC_AIR_SOI_TMS_RIGHT
    {
        displayName = "TMS Right";
        tooltip = "Send TMS Right to the active Sensor of Interest";

        onActivate = "if (!isNil 'itc_air_soi_fnc_ms_down') then { ['TMS', 'RIGHT'] call itc_air_soi_fnc_ms_down; };";
        onDeactivate = "if (!isNil 'itc_air_soi_fnc_ms_up') then { ['TMS', 'RIGHT'] call itc_air_soi_fnc_ms_up; };";
    };

    // DMS 

    // | `ITC_AIR_SOI_DMS_UP`        | DMS up              |
    // | `ITC_AIR_SOI_DMS_DOWN`      | DMS down            |
    // | `ITC_AIR_SOI_DMS_LEFT`      | DMS left            |
    // | `ITC_AIR_SOI_DMS_RIGHT`     | DMS right           |

    class ITC_AIR_SOI_DMS_UP
    {
        displayName = "DMS Up";
        tooltip = "Send DMS Up to the active Sensor of Interest";

        onActivate = "if (!isNil 'itc_air_soi_fnc_ms_down') then { ['DMS', 'UP'] call itc_air_soi_fnc_ms_down; };";
        onDeactivate = "if (!isNil 'itc_air_soi_fnc_ms_up') then { ['DMS', 'UP'] call itc_air_soi_fnc_ms_up; };";
    };


    class ITC_AIR_SOI_DMS_DOWN
    {
        displayName = "DMS Down";
        tooltip = "Send DMS Down to the active Sensor of Interest";

        onActivate = "if (!isNil 'itc_air_soi_fnc_ms_down') then { ['DMS', 'DOWN'] call itc_air_soi_fnc_ms_down; };";
        onDeactivate = "if (!isNil 'itc_air_soi_fnc_ms_up') then { ['DMS', 'DOWN'] call itc_air_soi_fnc_ms_up; };";
    };


    class ITC_AIR_SOI_DMS_LEFT
    {
        displayName = "DMS Left";
        tooltip = "Send DMS Left to the active Sensor of Interest";

        onActivate = "if (!isNil 'itc_air_soi_fnc_ms_down') then { ['DMS', 'LEFT'] call itc_air_soi_fnc_ms_down; };";
        onDeactivate = "if (!isNil 'itc_air_soi_fnc_ms_up') then { ['DMS', 'LEFT'] call itc_air_soi_fnc_ms_up; };";
    };


    class ITC_AIR_SOI_DMS_RIGHT
    {
        displayName = "DMS Right";
        tooltip = "Send DMS Right to the active Sensor of Interest";

        onActivate = "if (!isNil 'itc_air_soi_fnc_ms_down') then { ['DMS', 'RIGHT'] call itc_air_soi_fnc_ms_down; };";
        onDeactivate = "if (!isNil 'itc_air_soi_fnc_ms_up') then { ['DMS', 'RIGHT'] call itc_air_soi_fnc_ms_up; };";
    };
    
    
    // MFD 

    // | `ITC_AIR_MFD_CURSOR_TOGGLE` | MFD cursor          |
    // | `ITC_AIR_MFD_OPEN_L`        | Left MFD            |
    // | `ITC_AIR_MFD_OPEN_R`        | Right MFD           |
    // | `ITC_AIR_MFD_OPEN_TGP`      | WSO/TGP display     |
    class ITC_AIR_MFD_CURSOR_OPEN
    {
        displayName = "MFD Cursor Open";
        tooltip = "Open the MFD and UFC mouse controls";

        onActivate =
            "if (!isNil 'itc_air_mfd_fnc_cursorOpen') then { call itc_air_mfd_fnc_cursorOpen; };";
    };


    class ITC_AIR_MFD_CURSOR_CLOSE
    {
        displayName = "MFD Cursor Close";
        tooltip = "Close the MFD and UFC mouse controls";

        onActivate =
            "if (!isNil 'itc_air_mfd_fnc_cursorClose') then { call itc_air_mfd_fnc_cursorClose; };";
    };


    class ITC_AIR_MFD_TOGGLE_LEFT
    {
        displayName = "Toggle Left MFD";
        tooltip = "Show or hide the left MFD";

        onActivate =
            "if (!isNil 'itc_air_mfd_fnc_toggleDisplay') then { ['L'] call itc_air_mfd_fnc_toggleDisplay; };";
    };


    class ITC_AIR_MFD_TOGGLE_RIGHT
    {
        displayName = "Toggle Right MFD";
        tooltip = "Show or hide the right MFD";

        onActivate =
            "if (!isNil 'itc_air_mfd_fnc_toggleDisplay') then { ['R'] call itc_air_mfd_fnc_toggleDisplay; };";
    };

    // WSO/TGP dialog
    class ITC_AIR_MFD_OPEN_TGP
    {
        displayName = "Open WSO TGP";
        tooltip = "Open the legacy WSO targeting pod display";

        onActivate =
            "private _vehicle = vehicle player; if (!dialog && {_vehicle getVariable ['wso', false]} && {player != driver _vehicle}) then { createDialog 'TGP_DIALOG'; };";
    };

    // Weapons 

    // | `ITC_AIR_FCS_RELEASE`       | Weapon release      |

    class ITC_AIR_FCS_RELEASE
    {
        displayName = "Weapon Release";
        tooltip = "Release the selected weapon";

        onActivate =
            "if (!isNil 'itc_air_fcs_fnc_releaseDown' && {'FCS' in ((vehicle player) getVariable ['itc_air_systems', []])}) then { call itc_air_fcs_fnc_releaseDown; };";

        onDeactivate =
            "if (!isNil 'itc_air_fcs_fnc_releaseUp') then { call itc_air_fcs_fnc_releaseUp; };";
    };

    // Nav
    // | `ITC_AIR_WPT_NEXT`          | Next steerpoint     |
    // | `ITC_AIR_WPT_PREV`          | Previous steerpoint |

    class ITC_AIR_WPT_NEXT
    {
        displayName = "Next Steerpoint";
        tooltip = "Select the next steerpoint";

        onActivate =
            "if (!isNil 'itc_air_wpt_fnc_next' && {'WPT' in ((vehicle player) getVariable ['itc_air_systems', []])}) then { call itc_air_wpt_fnc_next; };";
    };


    class ITC_AIR_WPT_PREV
    {
        displayName = "Previous Steerpoint";
        tooltip = "Select the previous steerpoint";

        onActivate =
            "if (!isNil 'itc_air_wpt_fnc_prev' && {'WPT' in ((vehicle player) getVariable ['itc_air_systems', []])}) then { call itc_air_wpt_fnc_prev; };";
    };
    // ------------------------------------------------------------------------
    // Autopilot
    // ------------------------------------------------------------------------

    class ITC_AIR_AP_TOGGLE
    {
        displayName = "Autopilot Toggle";
        tooltip = "Enable or disable the autopilot";

        onDeactivate = "private _vehicle = vehicle player; if (!(_vehicle isKindOf 'Plane') || {driver _vehicle != player}) exitWith {}; if (!('AUTOPILOT' in (_vehicle getVariable ['itc_air_systems', []]))) exitWith {}; if (ITC_AP_isEnabled) then { [_vehicle] call itc_air_autopilot_fnc_disengage; if (ITC_AP_mode == 3) then { ITC_AP_mode = ['ALT','ALT/HDG','PATH'] find ITC_AP_modeString; }; } else { ITC_AP_isEnabled = true; [_vehicle, ITC_AP_mode] call itc_air_autopilot_fnc_autopilot; };";
    };


    class ITC_AIR_AP_MODE
    {
        displayName = "Autopilot Mode";
        tooltip = "Cycle the autopilot mode";

        onDeactivate = "private _vehicle = vehicle player; if (!(_vehicle isKindOf 'Plane') || {driver _vehicle != player}) exitWith {}; if ('AUTOPILOT' in (_vehicle getVariable ['itc_air_systems', []])) then { call itc_air_autopilot_fnc_autopilotToggleMode; };";
    };

    // ------------------------------------------------------------------------
    // System FWS 
    // ------------------------------------------------------------------------
    class ITC_AIR_FWS_ACK
    {
        displayName = "FWS Acknowledge";
        tooltip = "Acknowledge FWS Warnings";

        onActivate = "if (!isNil 'itc_air_fws_fnc_acknowledge') then { [vehicle player] call itc_air_fws_fnc_acknowledge; };";
    };

    // ------------------------------------------------------------------------
    // System Trim 
    // ------------------------------------------------------------------------
    class ITC_AIR_TRIM_PITCH_UP
    {
        displayName = "Pitch Trim Nose Up";
        tooltip = "Increase nose-up pitch trim";

        onActivate = "if (!isNil 'itc_air_trim_fnc_trimUp') then { _this call itc_air_trim_fnc_trimUp; };";
        onDeactivate = "if (!isNil 'itc_air_trim_fnc_trimUp') then { _this call itc_air_trim_fnc_trimUp; };";
    };


    class ITC_AIR_TRIM_PITCH_DOWN
    {
        displayName = "Pitch Trim Nose Down";
        tooltip = "Increase nose-down pitch trim";

        onActivate = "if (!isNil 'itc_air_trim_fnc_trimDown') then { _this call itc_air_trim_fnc_trimDown; };";
        onDeactivate = "if (!isNil 'itc_air_trim_fnc_trimDown') then { _this call itc_air_trim_fnc_trimDown; };";
    };


    class ITC_AIR_TRIM_PITCH_RESET
    {
        displayName = "Pitch Trim Reset";
        tooltip = "Reset pitch trim to neutral";

        onActivate = "if (!isNil 'itc_air_trim_fnc_trimReset') then { call itc_air_trim_fnc_trimReset; };";
    };
};
