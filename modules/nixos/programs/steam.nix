{ config, pkgs, ... }:

let
  # Keep Steam and every game it launches on the NVIDIA GPU while the laptop
  # remains in hybrid graphics mode.
  nvidiaOffloadEnvironment = {
    __NV_PRIME_RENDER_OFFLOAD = "1";
    __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    __VK_LAYER_NV_optimus = "NVIDIA_only";
  };
in
{
  programs.steam = {
    enable = true;

    # Apply PRIME offload only in Hybrid mode. Dedicated mode uses NVIDIA
    # directly, while integrated mode has no NVIDIA provider at all.
    package =
      if config.hardware.nvidia.enabled && config.hardware.nvidia.prime.offload.enable then
        pkgs.steam.override {
          extraEnv = nvidiaOffloadEnvironment;
        }
      else
        pkgs.steam;

    # Keep Valve Proton as the default and expose Proton-GE for games that need
    # its additional compatibility patches.
    extraCompatPackages = [ pkgs.proton-ge-bin ];

    # Translate Steam Input's X11 events for controllers under Niri/Wayland.
    extest.enable = true;
  };

  # Games opt in with the Steam launch option `gamemoderun %command%`.
  programs.gamemode.enable = true;
}
