{ config, pkgs, username, ... }:

{
  services.displayManager.gdm.enable = false;

  services.greetd = {
    enable = true;
    settings = {

      initial_session = {
        # Scope the class to the graphical child; setting it globally would also
        # override pam_systemd's manager class for user@.service.
        command = "${pkgs.coreutils}/bin/env XDG_SESSION_CLASS=user ${config.programs.niri.package}/bin/niri-session";
        user = username;
      };

      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --env XDG_SESSION_CLASS=user --sessions /run/current-system/sw/share/wayland-sessions:/run/current-system/sw/share/xsessions --cmd ${config.programs.niri.package}/bin/niri-session";
        user = "greeter";
      };
    };
  };
}
