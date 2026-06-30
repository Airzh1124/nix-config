{ ... }:

{
  imports = [
    ./packages.nix
    ./programs
  ];

  home.username = "han";
  home.homeDirectory = "/home/han";

  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  home.stateVersion = "26.05";
}
