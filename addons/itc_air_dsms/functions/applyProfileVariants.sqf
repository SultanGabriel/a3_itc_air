// Applies profile options that require a different pylon magazine.
// Currently used by CBU-87 pattern variants.
params ["_plane", "_weapon", "_profileOptions"];

private _patternProfileIndex = _profileOptions findIf {
  (_x # 0 == "pat") && {count _x > 5}
};
if(_patternProfileIndex == -1) exitWith {};

private _patternProfile = _profileOptions # _patternProfileIndex;
private _patternValues = _patternProfile # 4;

// Field #5 is a CBU-87-specific pattern-to-magazine variant map.
private _patternData = _patternProfile # 5;

private _patternValueIndex = _patternValues find (_patternProfile # 1);
if(_patternValueIndex == -1) exitWith {};

private _patternMagazineIndex = (_patternValueIndex * 2) + 1;
if(_patternMagazineIndex >= count _patternData) exitWith {};

private _patternMagazine = _patternData # _patternMagazineIndex;

private _pylonMagazines = getPylonMagazines _plane;

// Replace each matching pylon magazine with the variant for the selected pattern.
for "_i" from 0 to ((count _pylonMagazines) - 1) step 1 do {
  private _currentMagazine = _pylonMagazines # _i;

  if(_currentMagazine != "") then {
    private _pylonWeapon = getText (
      configFile >>
      "CfgMagazines" >>
      _currentMagazine >>
      "pylonWeapon"
    );

    if(
      _pylonWeapon == _weapon &&
      {_currentMagazine != _patternMagazine}
    ) then {
      _plane setPylonLoadout [
        _i + 1,
        _patternMagazine,
        true // Force the change, to bypass "hardpoint" check
      ];
    };
  };
};