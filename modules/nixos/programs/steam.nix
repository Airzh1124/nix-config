{ pkgs, ... }:

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

    # Apply PRIME offload to the whole Steam process tree so games use the
    # discrete GPU without requiring per-game launch options.
    package = pkgs.steam.override {
      extraEnv = nvidiaOffloadEnvironment;
    };

    # Keep Valve Proton as the default and expose Proton-GE for games that need
    # its additional compatibility patches.
    extraCompatPackages = [ pkgs.proton-ge-bin ];

    # Translate Steam Input's X11 events for controllers under Niri/Wayland.
    extest.enable = true;
  };

  # Games opt in with the Steam launch option `gamemoderun %command%`.
  programs.gamemode.enable = true;
}
