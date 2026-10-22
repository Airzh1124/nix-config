{
  lib,
  paths,
  pkgs,
  ...
}:

{
  services.displayManager.gdm.enable = false;

  services.greetd = {
    enable = true;
    # The boot-time autologin (initial_session) lives in lock.nix, which locks
    # that session with swaylock right away; tuigreet only appears after logout.
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
          "--cmd ${paths.user.waylandSessionFile}"
        ];
        user = "greeter";
      };
    };
  };
}
