params ["_ammo"];
private _optionsList = [];

private _clusterFuzeConfig = configFile >> "CfgAmmo" >> _ammo >> "ITC_clusterFuze";
if(isText _clusterFuzeConfig) then {
  private _clusterFuze = getText _clusterFuzeConfig;
  if(_clusterFuze != "") then {
    _optionsList pushBack ["clusterFuze",_clusterFuze,"FUZ","fixed"];
  };
};

private _clusterHofConfig = configFile >> "CfgAmmo" >> _ammo >> "ITC_clusterHOF";
private _clusterHofMinConfig = configFile >> "CfgAmmo" >> _ammo >> "ITC_clusterHOFMin";
private _clusterHofMaxConfig = configFile >> "CfgAmmo" >> _ammo >> "ITC_clusterHOFMax";
private _clusterDefaultHofConfig = configFile >> "CfgAmmo" >> _ammo >> "ITC_clusterDefaultHOF";
if(isNumber _clusterHofMinConfig && {isNumber _clusterHofMaxConfig}) then {
  private _clusterHofMin = getNumber _clusterHofMinConfig;
  private _clusterHofMax = getNumber _clusterHofMaxConfig;
  private _clusterDefaultHof = if(isNumber _clusterDefaultHofConfig) then {
    getNumber _clusterDefaultHofConfig
  } else {
    _clusterHofMin
  };
  private _clusterHofValidator = compile format ["(_this >= %1 && _this <= %2)", _clusterHofMin, _clusterHofMax];
  _optionsList pushBack [
    "hof",
    str _clusterDefaultHof,
    "HOF",
    "UFC",
    _clusterHofValidator
  ];
} else {
  if(isArray _clusterHofConfig) then {
    private _clusterHofValues = (getArray _clusterHofConfig) apply {str _x};
    if(count _clusterHofValues > 0) then {
      private _clusterDefaultHof = if(isNumber _clusterDefaultHofConfig) then {
        str (getNumber _clusterDefaultHofConfig)
      } else {
        _clusterHofValues # 0
      };
      _optionsList pushBack [
        "hof",
        _clusterDefaultHof,
        "HOF",
        "cycle",
        _clusterHofValues
      ];
    };
  };
};

private _clusterPatternConfig = configFile >> "CfgAmmo" >> _ammo >> "ITC_clusterPattern";
if(isArray _clusterPatternConfig) then {
  private _clusterPatternData = getArray _clusterPatternConfig;
  private _clusterPatternValues = [];
  for "_i" from 0 to ((count _clusterPatternData) - 1) step 2 do {
    if(_i + 1 < count _clusterPatternData) then {
      _clusterPatternValues pushBack (_clusterPatternData # _i);
    };
  };
  if(count _clusterPatternValues > 0) then {
    private _clusterPatternDefaultConfig = configFile >> "CfgAmmo" >> _ammo >> "ITC_clusterPatternDefault";
    private _clusterPatternDefault = if(isText _clusterPatternDefaultConfig) then {
      getText _clusterPatternDefaultConfig
    } else {
      _clusterPatternValues # 0
    };
    _optionsList pushBack [
      "pat",
      _clusterPatternDefault,
      "PAT",
      "cycle",
      _clusterPatternValues,
      _clusterPatternData
    ];
  };
};

_optionsList
