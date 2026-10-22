{
  lib,
  paths,
  pkgs,
  username,
  ...
}:

let
  # The compositor module provides this executable, so greetd stays
  # compositor-agnostic.
  session = "${paths.user.homeDirectory}/.wayland-session";
in
{
  services.displayManager.gdm.enable = false;

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        # Scope the class to the graphical child; setting it globally would also
        # override pam_systemd's manager class for user@.service.
        command = "${lib.getExe' pkgs.coreutils "env"} XDG_SESSION_CLASS=user ${session}";
        user = username;
      };

      default_session = {
        command = lib.concatStringsSep " " [
          (lib.getExe pkgs.tuigreet)
          "--time"
          "--remember"
          "--remember-session"
          "--sessions /run/current-system/sw/share/wayland-sessions:/run/current-system/sw/share/xsessions"
          "--env XDG_SESSION_CLASS=user"
          "--cmd ${session}"
        ];
        user = "greeter";
      };
    };
  };
}
