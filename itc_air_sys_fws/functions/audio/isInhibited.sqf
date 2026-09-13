params ["_vehicle", "_id"];

// GCAS owns landing detection. Inhibition affects audio, not visual lifetime.
if !(_id in ["PULL_UP", "TERRAIN", "ALTITUDE"]) exitWith {false};
if (isNil "itc_air_gcas_fnc_isLanding") exitWith {false};

[_vehicle] call itc_air_gcas_fnc_isLanding
