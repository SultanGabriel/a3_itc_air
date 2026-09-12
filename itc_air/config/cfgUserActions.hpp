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
            "ITC_AIR_TRIM_PITCH_RESET"
        };
    };
};


// FIXME migrate all controls slowly to here
class CfgUserActions
{
    class ITC_AIR_FWS_ACK
    {
        displayName = "FWS Acknowledge";
        tooltip = "Acknowledge FWS Warnings";

        onActivate = "if (!isNil 'itc_air_fws_fnc_acknowledge') then { call itc_air_fws_fnc_acknowledge; };";
    };


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