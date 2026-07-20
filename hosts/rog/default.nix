{ ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/base.nix

    #desktop
    ../../modules/nixos/desktop/greetd.nix
    ../../modules/nixos/desktop/niri.nix
    ../../modules/nixos/desktop/input.nix
    ../../modules/nixos/desktop/keyring.nix
    ../../modules/nixos/desktop/lockscreen.nix
    ../../modules/nixos/desktop/stylix.nix

    #hardware
    ../../modules/nixos/hardware/asus-rog.nix
    ../../modules/nixos/hardware/graphics.nix
    ../../modules/nixos/hardware/nvidia.nix

    #services
    ../../modules/nixos/services/audio.nix
    ../../modules/nixos/services/bluetooth.nix
    ../../modules/nixos/services/mihomo.nix
    ../../modules/nixos/services/openssh.nix
    ../../modules/nixos/services/sunshine.nix
    ../../modules/nixos/services/syncthing.nix
    ../../modules/nixos/services/tailscale.nix

    #system
    ../../modules/nixos/system/maintenance.nix
    ../../modules/nixos/system/memory.nix

    #users
    ../../users
  ];

  networking.hostName = "rog";
}
