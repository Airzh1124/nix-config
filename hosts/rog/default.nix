{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/base.nix
    ../../modules/nixos/desktop/gnome.nix
    ../../modules/nixos/hardware/nvidia-prime.nix
    ../../modules/nixos/programs/fish.nix
    ../../modules/nixos/services/openssh.nix
    ../../users/han
  ];

  networking.hostName = "rog";
}
