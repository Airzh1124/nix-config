{ username, paths, ... }:

{
  imports = [
    ./desktop.nix
    ./packages.nix
    ./programs
  ];

  home.username = username;
  home.homeDirectory = paths.user.homeDirectory;
  home.stateVersion = "26.05";
}
