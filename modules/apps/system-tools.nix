{ config, pkgs, ... }:

{
  hm.programs.btop = {
    enable = true;
    # Show NVIDIA GPU stats where the driver is loaded; Stylix manages the theme.
    package = pkgs.btop.override { cudaSupport = config.hardware.nvidia.enabled; };
  };

  hm.programs.fastfetch.enable = true;

  hm.home.packages = with pkgs; [
    # Resource monitoring
    iftop
    iotop
    lm_sensors
    sysstat

    # Debugging and inspection
    lsof
    ltrace
    strace

    # Hardware and network inspection
    ethtool
    iw
    pciutils
    usbutils
  ];
}
