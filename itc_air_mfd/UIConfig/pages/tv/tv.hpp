class ITC_MFD_PAGE_TV : ITC_AIR_PAGE
{
    idc = 10802;

    class Controls
    {
        class TVPicture: RscPicture
        {
            idc = 108200;

            x = SCALE * 0.1125;
            y = SCALE * 0.16;
            w = SCALE * 0.525;
            h = SCALE * 0.7;

            colorBackground[] = {0, 0, 0, 0};
            colorText[] = {1, 1, 1, 1};

            text = "#(argb,512,512,1)r2t(GBU15_FEED,1)";
        };
    };
};