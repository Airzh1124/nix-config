{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/base.nix
    ../../modules/nixos/desktop/greetd.nix
    ../../modules/nixos/desktop/hyprland.nix
    ../../modules/nixos/desktop/input.nix
    ../../modules/nixos/hardware/asus-rog.nix
    ../../modules/nixos/hardware/nvidia.nix
    ../../modules/nixos/programs/fish.nix
    ../../modules/nixos/services/openssh.nix
    ../../modules/nixos/system/memory.nix
    ../../users/han
  ];

  networking.hostName = "rog";
}
