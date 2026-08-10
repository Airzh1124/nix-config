{ config, ... }:

{
  boot.blacklistedKernelModules = [ "nouveau" ];

  # Let the GPU currently driving the internal panel expose its native
  # backlight interface in both Hybrid and dedicated-GPU MUX modes.
  boot.kernelParams = [ "acpi_backlight=native" ];

  # NVIDIA does not expose its native backlight device by default; it is
  # required when the MUX connects the internal panel directly to the dGPU.
  boot.extraModprobeConfig = ''
    options nvidia NVreg_RegistryDwords=EnableBrightnessControl=1
  '';

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    nvidiaPersistenced = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;

    # Hybrid/Standard mode keeps the desktop on Intel and wakes NVIDIA for
    # explicitly offloaded applications such as Steam.
    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:2:0:0";
    };
  };
}
