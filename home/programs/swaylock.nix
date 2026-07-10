{ pkgs, ... }:

let
  wallpaper = ../../assets/wallpapers/wallpaper_nixos.jpg;
in
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock;

    settings = {
      ignore-empty-password = true;
      show-failed-attempts = true;

      image = "${wallpaper}";
      scaling = "fill";
    };
  };
}