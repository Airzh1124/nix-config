{ ... }:

let
  modules = ../../modules;
in
{
  imports = [
    ./hardware-configuration.nix
    ./audio.nix
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
    (modules + /hardware/asus-rog.nix)
    (modules + /hardware/atk-rs6-air.nix)
    (modules + /hardware/audio.nix)
    (modules + /hardware/bluetooth.nix)
    (modules + /hardware/intel-graphics.nix)
    (modules + /hardware/nvidia.nix)
    (modules + /hardware/razer-viper-v4-pro.nix)

    # Apps
    (modules + /apps/hkuvpn.nix)

    # Programs
    (modules + /nixos/programs/nix-ld.nix)
    (modules + /nixos/programs/steam.nix)

    # Services
    (modules + /nixos/services/mihomo.nix)
    (modules + /nixos/services/openssh.nix)
    (modules + /nixos/services/sunshine.nix)
    (modules + /nixos/services/syncthing.nix)
    (modules + /nixos/services/tailscale.nix)
  ];

  networking.hostName = "rog";

  # PRIME offload in the nvidia-hybrid specialisation (see `lspci -D`).
  specialisation.nvidia-hybrid.configuration.hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:2:0:0";
  };
}
