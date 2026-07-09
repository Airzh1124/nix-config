{ config, pkgs, username, ... }:

{
  services.displayManager.gdm.enable = false;

  services.greetd = {
    enable = true;
    settings = {

      initial_session = {
        command = "${config.programs.niri.package}/bin/niri-session";
        user = username;
      };

      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions /run/current-system/sw/share/wayland-sessions:/run/current-system/sw/share/xsessions --cmd ${config.programs.niri.package}/bin/niri-session";
        user = "greeter";
      };
    };
  };
}
