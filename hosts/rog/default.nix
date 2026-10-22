{ ... }:

let
  modules = ../../modules;
in
{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix

    # Core
    (modules + /core/boot.nix)
    (modules + /core/home-manager.nix)
    (modules + /core/nix.nix)
    (modules + /core/system.nix)
    (modules + /core/user.nix)

    # Desktop
    (modules + /nixos/desktop/greetd.nix)
    (modules + /nixos/desktop/niri.nix)
    (modules + /nixos/desktop/input.nix)
    (modules + /nixos/desktop/keyring.nix)
    (modules + /nixos/desktop/lockscreen.nix)
    (modules + /nixos/desktop/stylix.nix)

    # Hardware
    (modules + /nixos/hardware/asus-rog.nix)
    (modules + /nixos/hardware/atk-rs6-air.nix)
    (modules + /nixos/hardware/razer-viper-v4-pro.nix)
    (modules + /nixos/hardware/graphics.nix)
    (modules + /nixos/hardware/nvidia.nix)

    # Apps
    (modules + /apps/hkuvpn.nix)

    # Programs
    (modules + /nixos/programs/nix-ld.nix)
    (modules + /nixos/programs/steam.nix)

    # Services
    (modules + /nixos/services/audio.nix)
    (modules + /nixos/services/bluetooth.nix)
    (modules + /nixos/services/mihomo.nix)
    (modules + /nixos/services/openssh.nix)
    (modules + /nixos/services/sunshine.nix)
    (modules + /nixos/services/syncthing.nix)
    (modules + /nixos/services/tailscale.nix)
  ];

  networking.hostName = "rog";
}
