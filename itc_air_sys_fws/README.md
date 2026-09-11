# ITC AIR Flight Warning System (FWS)
# consider rebranding to : EICAS (Engine-Indicating and Crew-Alerting System):

# Future File structure
```cpp
itc_air_sys_fws/
│
├── config.cpp
├── README.md
│
├── config/
│   ├── cfgFunctions.hpp
│   └── cfgSounds.hpp
│
├── functions/
│   │
│   ├── core/
│   │   ├── init.sqf                    // Define FWS defaults and initialize global/static data.
│   │   ├── setup.sqf                   // Initialize FWS for one aircraft and add MFD settings.
│   │   ├── shutDown.sqf                // Stop audio and clear aircraft-local FWS runtime state.
│   │   ├── perFrame.sqf                // Run warning arbitration and active audio playback.
│   │   └── perSecond.sqf               // Run low-rate internal monitors such as fuel and damage.
│   │
│   ├── warnings/
│   │   ├── definitions.sqf             // Define warning IDs, classes, priorities, sounds and behavior.
│   │   ├── getDefinition.sqf           // Return the definition for one warning ID.
│   │   ├── setWarning.sqf              // Set or clear a persistent STATE warning.
│   │   ├── triggerWarning.sqf          // Add a one-shot EVENT warning with timeout.
│   │   ├── acknowledgeWarning.sqf      // Acknowledge one warning when allowed.
│   │   ├── acknowledgeAll.sqf          // Acknowledge all currently acknowledgeable warnings.
│   │   ├── getActiveWarnings.sqf       // Return current active warnings for HUD/MFD consumers.
│   │   └── hasWarning.sqf              // Return whether one warning is currently active.
│   │
│   ├── audio/
│   │   ├── resolve.sqf                 // Select the highest-priority warning allowed to sound.
│   │   ├── startWarning.sqf            // Start the selected warning's audio sequence.
│   │   ├── finishWarning.sqf           // Finish playback and update repeat/event state.
│   │   └── interruptCurrent.sqf        // Stop lower-priority audio when pre-empted.
│   │
│   ├── monitoring/
│   │   ├── fuel/
│   │   │   ├── initFuel.sqf            // Initialize fuel thresholds and re-arm state.
│   │   │   └── monitorFuel.sqf         // Generate BINGO/FUEL_LOW from generic Arma fuel state.
│   │   │
│   │   └── damage/
│   │       ├── initDamage.sqf          // Initialize damage-monitor state.
│   │       ├── monitorDamage.sqf       // Read relevant hit points and derive warning conditions.
│   │       └── getDamageState.sqf      // Normalize selected hit-point damage for warning logic.
│   │
│   └── ui/
│       ├── getDisplayWarnings.sqf      // Prepare active warnings/cautions for later HUD/MFD use.
│       └── acknowledgeCurrent.sqf      // UI-facing ACK action for the current warning set.
│
└── sounds/
    ├── caution.ogg
    ├── warning.ogg
    ├── pull_up.ogg
    ├── terrain.ogg
    ├── low_altitude.ogg
    ├── check_gear.ogg
    ├── ap_disconnect.ogg
    ├── bingo.ogg
    ├── fuel_low.ogg
    └── ...
```

## Description
`itc_air_sys_fws` provides the central flight warning system for ITC AIR aircraft.

The FWS does not replace specialist aircraft systems such as GCAS, EW, FCS, or the autopilot. These systems remain responsible for detecting conditions that belong to them. They report warning states or warning events to the FWS.

For example, GCAS decides when a terrain threat or pull-up condition exists. EW decides when a radar or missile threat exists. The autopilot decides when an autopilot disconnect occurs. The FWS does not repeat these calculations.

The FWS is responsible for collecting these warnings, storing their current state, assigning priority, applying inhibit and acknowledgement rules, and controlling the related audio output.

The FWS can also monitor simple generic aircraft information when no other ITC AIR system owns that information. Initial examples are fuel quantity and selected aircraft damage states. This monitoring exists only to generate warnings. The FWS is not intended to become a complete fuel, damage, engine, or flight-control simulation.

Persistent warning conditions use `setWarning`. The system that creates the warning also owns its lifetime and must clear it when the condition is no longer valid.

Example:

```sqf
[_plane, "PULL_UP", true] call itc_air_fws_fnc_setWarning;
[_plane, "PULL_UP", false] call itc_air_fws_fnc_setWarning;
```

One-shot conditions use `triggerWarning`. After an event is triggered, the FWS owns its remaining lifetime. The event is played once when permitted by warning priority, or it expires if it cannot be presented within its configured time.

Example:

```sqf
[_plane, "AP_DISCONNECT"] call itc_air_fws_fnc_triggerWarning;
```

The FWS keeps warning state separate from audio state. A warning can remain active and visible while its audio is inhibited, acknowledged, or disabled.

Warnings can define whether acknowledgement is allowed. Normal cautions can usually be acknowledged so that repeated audio stops while the warning remains active. Critical warnings such as `PULL_UP` can be configured as non-acknowledgeable and continue to sound while the dangerous condition exists.

The FWS maintains priority between simultaneous warnings. A higher-priority warning can inhibit lower-priority audio without removing the lower-priority warning state. When the higher-priority condition clears, a lower warning can become audible again if it remains active and has not been acknowledged.

The FWS exposes its active warning state for use by other ITC AIR components. Future HUD and MFD integration can therefore display warnings without directly reading implementation-specific variables from GCAS, fuel monitoring, damage monitoring, or other producer systems.

The initial implementation focuses on GCAS warnings, autopilot disconnect, basic fuel monitoring, basic damage-derived warnings, warning acknowledgement, and aural warning control. Additional systems can later report warnings through the same FWS interface without moving their detection logic into the FWS.

The aircraft configuration must include `"FWS"` in its ITC AIR `systems[]` list when the aircraft uses FWS warnings.

The MFD options include an `FWS AUDIO` control. Disabling this option disables aural output only. Warning detection, warning state, GCAS operation, and other aircraft systems continue to operate normally.
