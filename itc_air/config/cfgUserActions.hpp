class UserActionGroups
{
    class ITC_AIR
    {
        name = "ITC AIR";
        isAddon = 1;

        group[] =
        {
            "ITC_AIR_FWS_ACK"
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
};