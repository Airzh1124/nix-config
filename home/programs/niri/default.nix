{ paths, ... }:

{
  xdg.configFile."niri/config.kdl".text = ''
    include "${paths.user.niriConfigDirectory}/config.kdl"
  '';

  # Switch to the desk monitor when connected, and restore the laptop panel when unplugged.
  services.kanshi = {
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
              mode = "2560x1440@240.002Hz";
              scale = 1.0;
            }
          ];
        };
      }
    ];
  };
}
