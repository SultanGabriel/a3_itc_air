/*
 * Author: BlackHawk
 *
 * Initializes Autopilot (AP) component by adding CBA keybinds and initializing global variables.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * [] call itc_fnc_autpilotInit;
 *
 * Public: No
 */

// TODO
//* debug macro
//* use something better than hint for user feedback
//* move macro values to config (?)
//* calculate derivative of velocity (acceleration) to better predict where VV will go and make autopilot line up quicker
//  right now if force is a little bit too big, the plane starts to wobble wildly - lots of force is applied
//  when VV is far off, and it stops only when we reached target VV, but then it's too late, nose is still moving
//* use macros for global variables
//* use pitch + roll torque instead of vertical force - will require math
