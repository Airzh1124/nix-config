{ paths, ... }:

{
  # Output modes and scales for this laptop and its desk monitor.
  hm.xdg.configFile."niri/config.kdl".text = ''
    include "${paths.user.hostDirectory}/niri-outputs.kdl"
  '';

  # Switch to the desk monitor when connected, and restore the laptop panel when unplugged.
  # kanshi only toggles outputs on and off; modes and scales live solely in
  # niri-outputs.kdl. kanshi sends no mode/scale for fields left unset, so niri
  # keeps applying the ones from its config.
  hm.services.kanshi = {
    enable = true;
    settings = [
      {
        profile = {
          name = "mobile";
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
            }
          ];
        };
      }
      {
        profile = {
          name = "desk";
          outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "PNP(AOC) Q24G41ZE XLSRCHA006583";
              status = "enable";
            }
          ];
        };
      }
    ];
  };
}
