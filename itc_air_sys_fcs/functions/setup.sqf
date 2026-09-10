itc_air_fcs_ccip_resultIndex = -1;
itc_air_fcs_ccip_impactPos = [0,0,0];
itc_air_fcs_ccip_enabled = false;

// New time-based CCIP solver state
itc_air_fcs_ccip_rawPos = [0,0,0];
itc_air_fcs_ccip_solutionVelocity = [0,0,0];
itc_air_fcs_ccip_lastSolveTime = -1;
itc_air_fcs_ccip_nextSolveTime = 0;

itc_air_fcs_numSamples = 10;

itc_air_fcs_posSamples = [];
for "_i" from 1 to itc_air_fcs_numSamples do {
  itc_air_fcs_posSamples = [itc_air_fcs_posSamples,  [0,0,0]] call BIS_fnc_arrayPush;
};
itc_air_fcs_sampleIndex = 0;
itc_air_fcs_sampleRatio = 1/itc_air_fcs_numSamples;

itc_air_fcs_trajectoryPositions = [];
itc_air_fcs_currentPlane = objNull;
itc_air_fcs_currentProvider = [];
