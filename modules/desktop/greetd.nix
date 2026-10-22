{
  lib,
  paths,
  pkgs,
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
    # No initial_session autologin: logging in through tuigreet hands the
    # password to PAM, which unlocks GNOME Keyring in the same step. Autologin
    # skipped that and left a keyring unlock prompt after reaching the desktop.
    settings = {
      default_session = {
        command = lib.concatStringsSep " " [
          (lib.getExe pkgs.tuigreet)
          "--time"
          "--remember"
          "--remember-session"
          "--sessions /run/current-system/sw/share/wayland-sessions:/run/current-system/sw/share/xsessions"
          # Scope the class to the graphical child; setting it globally would also
          # override pam_systemd's manager class for user@.service.
          "--env XDG_SESSION_CLASS=user"
          "--cmd ${session}"
        ];
        user = "greeter";
      };
    };
  };
}
