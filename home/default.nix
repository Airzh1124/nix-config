{ pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./programs
  ];

  home.username = "han";
  home.homeDirectory = "/home/han";

  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  xresources.properties = {
    "Xcursor.theme" = "Bibata-Modern-Classic";
    "Xcursor.size" = 24;
    "Xft.dpi" = 172;
  };

  home.stateVersion = "26.05";
}
