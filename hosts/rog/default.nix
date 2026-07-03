{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/base.nix

    #desktop
    ../../modules/nixos/desktop/greetd.nix
    ../../modules/nixos/desktop/hyprland.nix
    ../../modules/nixos/desktop/input.nix

    #hardware
    ../../modules/nixos/hardware/asus-rog.nix
    ../../modules/nixos/hardware/nvidia.nix

    #programs
    ../../modules/nixos/programs/fish.nix

    #services
    ../../modules/nixos/services/audio.nix
    ../../modules/nixos/services/openssh.nix
    ../../modules/nixos/services/syncthing.nix

    #system
    ../../modules/nixos/system/memory.nix

    #users
    ../../users/han
  ];

  networking.hostName = "rog";
}
