{ ... }:

let
  modules = ../../modules;
in
{
  imports = [
    ./hardware-configuration.nix
    ./audio.nix
    ./display.nix
    ./networking.nix

    # Core
    (modules + /core/boot.nix)
    (modules + /core/home-manager.nix)
    (modules + /core/nix.nix)
    (modules + /core/system.nix)
    (modules + /core/user.nix)

    # Desktop
    (modules + /desktop/appearance.nix)
    (modules + /desktop/default-apps.nix)
    (modules + /desktop/fonts.nix)
    (modules + /desktop/greetd.nix)
    (modules + /desktop/input-method)
    (modules + /desktop/keyring.nix)
    (modules + /desktop/lock.nix)
    (modules + /desktop/niri)
    (modules + /desktop/noctalia)
    (modules + /desktop/vicinae.nix)

    # Hardware
    (modules + /hardware/asus-rog.nix)
    (modules + /hardware/atk-rs6-air.nix)
    (modules + /hardware/audio.nix)
    (modules + /hardware/bluetooth.nix)
    (modules + /hardware/intel-graphics.nix)
    (modules + /hardware/nvidia.nix)
    (modules + /hardware/razer-viper-v4-pro.nix)

    # Apps
    (modules + /apps/browsers.nix)
    (modules + /apps/documents.nix)
    (modules + /apps/gaming.nix)
    (modules + /apps/hkuvpn.nix)
    (modules + /apps/media.nix)
    (modules + /apps/monitoring.nix)
    (modules + /apps/nautilus.nix)
    (modules + /apps/ollama.nix)
    (modules + /apps/packages.nix)
    (modules + /apps/wechat.nix)

    # Development
    (modules + /dev/git.nix)
    (modules + /dev/kitty.nix)
    (modules + /dev/llm-agents)
    (modules + /dev/nix-ld.nix)
    (modules + /dev/shell.nix)
    (modules + /dev/vscode.nix)
    (modules + /dev/yazi)
    (modules + /dev/zed.nix)

    # Services
    (modules + /services/mihomo.nix)
    (modules + /services/openssh.nix)
    (modules + /services/sunshine.nix)
    (modules + /services/syncthing.nix)
    (modules + /services/tailscale.nix)
  ];

  networking.hostName = "rog";

  # PRIME offload in the nvidia-hybrid specialisation (see `lspci -D`).
  specialisation.nvidia-hybrid.configuration.hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:2:0:0";
  };
}
