params ["_plane", "_frameTime"];

private _now = diag_tickTime;

// Full ballistic calculation rate.
// 0.05 seconds = 20 Hz.
private _solveInterval = 0.05;

// Run the expensive ballistic solver at a fixed rate independent of FPS.
if (_now >= itc_air_fcs_ccip_nextSolveTime) then {
  // Schedule from now so a frame hitch does not cause catch-up calculations.
  itc_air_fcs_ccip_nextSolveTime = _now + _solveInterval;

  itc_air_fcs_ccip_enabled = true;
  itc_air_fcs_startTime = diag_tickTime;

  private _info = [_plane] call itc_air_fcs_fnc_getDrawPos;
  itc_air_fcs_endTime = diag_tickTime;

  if (!isNil {_info} && {count _info >= 2}) then {
    if (count _info == 4) then {
      itc_air_fcs_ccip_impactTime = _info # 3;
    };

    private _newPos = _info # 0;
    itc_air_fcs_ccip_resultIndex = _info # 1;

    // Measure how quickly the ballistic solution itself is moving.
    if (itc_air_fcs_ccip_lastSolveTime >= 0) then {
      private _dt = _now - itc_air_fcs_ccip_lastSolveTime;

      if (_dt > 0) then {
        itc_air_fcs_ccip_solutionVelocity =
          ((_newPos vectorDiff itc_air_fcs_ccip_rawPos) vectorMultiply (1 / _dt));
      };
    } else {
      // Snap the first valid solution because there is no previous point to interpolate.
      itc_air_fcs_ccip_impactPos = _newPos;
      itc_air_fcs_ccip_solutionVelocity = [0,0,0];
    };

    itc_air_fcs_ccip_rawPos = _newPos;
    itc_air_fcs_ccip_lastSolveTime = _now;
  };
};

// Cheap every-frame display prediction.
if (itc_air_fcs_ccip_lastSolveTime >= 0) then {
  // Never extrapolate very far if the solver gets delayed.
  private _predictionAge = (((_now - itc_air_fcs_ccip_lastSolveTime) max 0) min 0.075);
  private _predictedPos =
    itc_air_fcs_ccip_rawPos vectorAdd
    (itc_air_fcs_ccip_solutionVelocity vectorMultiply _predictionAge);

  // Time-based display smoothing, approximately 50 ms response time.
  private _smoothTime = 0.05;
  private _alpha = 1 - exp (-((_frameTime max 0) / _smoothTime));

  itc_air_fcs_ccip_impactPos =
    itc_air_fcs_ccip_impactPos vectorAdd
    ((_predictedPos vectorDiff itc_air_fcs_ccip_impactPos) vectorMultiply _alpha);
};
