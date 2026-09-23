class cfgFunctions {
  class itc_air_soi {
    class functions {
      class init {
        postInit = 1;
        file = "itc_air_soi\functions\init.sqf";
      };
      class setup {
        file = "itc_air_soi\functions\setup.sqf";
      };
      class cycle {
        file = "itc_air_soi\functions\cycle.sqf";
      };
      // class down {
      //   file = "itc_air_soi\functions\down.sqf";
      // };
      // class up {
      //   file = "itc_air_soi\functions\up.sqf";
      // }; FIXME
      class ms_down {
        file = "itc_air_soi\functions\ms\down.sqf";
      };
      class ms_up {
        file = "itc_air_soi\functions\ms\up.sqf";
      };
      class slewInput
      {
          file = "itc_air_soi\functions\slewInput.sqf";
      };
      class perFrame {
        file = "itc_air_soi\functions\perFrame.sqf";
      };
    };
  };
};
