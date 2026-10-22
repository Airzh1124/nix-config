{ paths, ... }:

{
  # Output modes and scales for this laptop and its desk monitor. niri turns
  # the laptop panel off by itself while the lid is closed and an external
  # monitor is connected, so no kanshi profiles are needed.
  hm.xdg.configFile."niri/config.kdl".text = ''
    include "${paths.user.hostDirectory}/niri-outputs.kdl"
  '';
}
