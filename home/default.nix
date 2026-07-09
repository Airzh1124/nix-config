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
    size = 32;
    gtk.enable = true;
    x11.enable = true;
  };

  xresources.properties = {
    "Xft.dpi" = 192;
  };

  home.stateVersion = "26.05";
}
