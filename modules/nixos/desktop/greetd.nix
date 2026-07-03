{ config, pkgs, username, ... }:

{
  services.displayManager.gdm.enable = false;

  services.greetd = {
    enable = true;
    settings = {

      initial_session = {
        command = "start-hyprland";
        user = username;
      };

      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions /run/current-system/sw/share/wayland-sessions:/run/current-system/sw/share/xsessions --cmd ${config.programs.hyprland.package}/bin/start-hyprland";
        user = "greeter";
      };
    };
  };
}
