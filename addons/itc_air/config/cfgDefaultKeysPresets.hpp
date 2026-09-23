
class CfgDefaultKeysPresets
{
    class Arma2 // inherited by the other Arma 3 presets
    {
        class Mappings
        {
            // -----------------------------------------------------------------
            // FWS
            // -----------------------------------------------------------------
            ITC_AIR_FWS_ACK[] = {};


            // -----------------------------------------------------------------
            // Pitch Trim
            // -----------------------------------------------------------------
            ITC_AIR_TRIM_PITCH_UP[] = {};
            ITC_AIR_TRIM_PITCH_DOWN[] = {};
            ITC_AIR_TRIM_PITCH_RESET[] = {};


            // -----------------------------------------------------------------
            // SOI
            // -----------------------------------------------------------------

            // DIK_INSERT / 210
            ITC_AIR_SOI_CYCLE[] =
            {
                0xD2
            };

            // Arrow keys
            ITC_AIR_SOI_SLEW_UP[] =
            {
                0xC8
            };

            ITC_AIR_SOI_SLEW_DOWN[] =
            {
                0xD0
            };

            ITC_AIR_SOI_SLEW_LEFT[] =
            {
                0xCB
            };

            ITC_AIR_SOI_SLEW_RIGHT[] =
            {
                0xCD
            };


            // -----------------------------------------------------------------
            // TMS
            // -----------------------------------------------------------------
            // Alt + Arrow keys

            ITC_AIR_SOI_TMS_UP[] =
            {
                0x381300C8, // Left Alt  + Up
                0xB81300C8  // Right Alt + Up
            };

            ITC_AIR_SOI_TMS_DOWN[] =
            {
                0x381300D0, // Left Alt  + Down
                0xB81300D0  // Right Alt + Down
            };

            ITC_AIR_SOI_TMS_LEFT[] =
            {
                0x381300CB, // Left Alt  + Left
                0xB81300CB  // Right Alt + Left
            };

            ITC_AIR_SOI_TMS_RIGHT[] =
            {
                0x381300CD, // Left Alt  + Right
                0xB81300CD  // Right Alt + Right
            };


            // -----------------------------------------------------------------
            // DMS
            // -----------------------------------------------------------------
            // Ctrl + W/S/A/D

            ITC_AIR_SOI_DMS_UP[] =
            {
                0x1D130011, // Left Ctrl  + W
                0x9D130011  // Right Ctrl + W
            };

            ITC_AIR_SOI_DMS_DOWN[] =
            {
                0x1D13001F, // Left Ctrl  + S
                0x9D13001F  // Right Ctrl + S
            };

            ITC_AIR_SOI_DMS_LEFT[] =
            {
                0x1D13001E, // Left Ctrl  + A
                0x9D13001E  // Right Ctrl + A
            };

            ITC_AIR_SOI_DMS_RIGHT[] =
            {
                0x1D130020, // Left Ctrl  + D
                0x9D130020  // Right Ctrl + D
            };


            // -----------------------------------------------------------------
            // MFD
            // -----------------------------------------------------------------

            // Ctrl + Up
            ITC_AIR_MFD_CURSOR_OPEN[] =
            {
                0x1D1300C8, // Left Ctrl  + Up
                0x9D1300C8  // Right Ctrl + Up
            };

            // New action; no legacy default.
            ITC_AIR_MFD_CURSOR_CLOSE[] = {};

            // Ctrl + Left
            ITC_AIR_MFD_TOGGLE_LEFT[] =
            {
                0x1D1300CB, // Left Ctrl  + Left
                0x9D1300CB  // Right Ctrl + Left
            };

            // Ctrl + Right
            ITC_AIR_MFD_TOGGLE_RIGHT[] =
            {
                0x1D1300CD, // Left Ctrl  + Right
                0x9D1300CD  // Right Ctrl + Right
            };

            // WSO/TGP fullscreen dialog: Shift + Down
            // FIXME current actual usage is unclear
            ITC_AIR_MFD_OPEN_TGP[] =
            {
                0x2A1300D0, // Left Shift  + Down
                0x361300D0  // Right Shift + Down
            };


            // -----------------------------------------------------------------
            // FCS
            // -----------------------------------------------------------------

            // Space
            ITC_AIR_FCS_RELEASE[] =
            {
                0x39
            };


            // -----------------------------------------------------------------
            // WPT / Steerpoint
            // -----------------------------------------------------------------

            // Page Up / DIK_PRIOR / 201
            ITC_AIR_WPT_NEXT[] =
            {
                0xC9
            };

            // Page Down / DIK_NEXT / 209
            ITC_AIR_WPT_PREV[] =
            {
                0xD1
            };


            // -----------------------------------------------------------------
            // Autopilot
            // -----------------------------------------------------------------

            // Ctrl + Tab
            ITC_AIR_AP_TOGGLE[] =
            {
                0x1D13000F, // Left Ctrl  + Tab
                0x9D13000F  // Right Ctrl + Tab
            };

            // Shift + Tab
            ITC_AIR_AP_MODE[] =
            {
                0x2A13000F, // Left Shift  + Tab
                0x3613000F  // Right Shift + Tab
            };
        };
    };
};
