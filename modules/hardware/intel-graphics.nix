{ pkgs, ... }:

{
  hardware.graphics = {
    enable = true;

    # Provide Intel's iHD VA-API driver for Quick Sync video decode/encode.
    # Keep this in the system graphics stack so libva can discover it globally.
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
    ];
  };
}
