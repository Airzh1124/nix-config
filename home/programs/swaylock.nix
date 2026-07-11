{ pkgs, paths, ... }:

let
  wallpaper = paths.assets.wallpapers.nixos;
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
