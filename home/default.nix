{ ... }:

{
  # Identity and stateVersion live in modules/core/home-manager.nix.
  imports = [
    ./desktop.nix
    ./packages.nix
    ./programs
  ];
}
