Expected sound files for the initial FWS module:

  caution.ogg
  warning.ogg
  pull_up.ogg
  terrain.ogg
  low_altitude.ogg
  check_gear.ogg

warning.ogg is reserved for later warning-class messages and is not used by the
initial registry yet.

Voice entries are played with playSound's speech flag. Tones are played as
normal sounds. Replace the files without changing producer code.
