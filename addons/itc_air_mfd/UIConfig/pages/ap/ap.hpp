#include ".\apMfdDefines.hpp" // FIXME remember this pattern

class MFDAP : ITC_AIR_PAGE {
  idc = MFD_AP_PAGE;
  class Controls {
    class APTitle : ITC_AIR_MfdTextCenter {
      idc = MFD_AP_TITLE;
      x = SCALE * 0.20;
      y = SCALE * 0.20;
      w = SCALE * 0.35;
      h = SCALE * 0.04;
    };
    class APStatus : ITC_AIR_MfdTextCenter {
      idc = 43001;
      x = SCALE * 0.18;
      y = SCALE * 0.29;
      w = SCALE * 0.35;
      h = SCALE * 0.04;
    };
    class APInfo : ITC_AIR_MfdTextCenter {
      idc = 43002;
      x = SCALE * 0.20;
      y = SCALE * 0.38;
      w = SCALE * 0.35;
      h = SCALE * 0.04;
    };
    class APDetail : ITC_AIR_MfdTextCenter {
      idc = 43003;
      x = SCALE * 0.20;
      y = SCALE * 0.47;
      w = SCALE * 0.35;
      h = SCALE * 0.04;
    };
    class APFooter : ITC_AIR_MfdTextCenter {
      idc = 43004;
      x = SCALE * 0.20;
      y = SCALE * 0.56;
      w = SCALE * 0.35;
      h = SCALE * 0.04;
    };
  };
};
