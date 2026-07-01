{ config, ... }:

{
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.kernelParams = [ "acpi_backlight=native" ];
  boot.extraModprobeConfig = ''
    options nvidia NVreg_RegistryDwords=EnableBrightnessControl=1
  '';

  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    nvidiaPersistenced = true;
    powerManagement.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;

    # Enable this block when using Hybrid/Standard mode
    # (gpu_mux_mode=1, dgpu_disable=0) for NVIDIA PRIME render offload.
    # prime = {
    #   offload.enable = true;
    #   offload.enableOffloadCmd = true;
    #   intelBusId = "PCI:0:2:0";
    #   nvidiaBusId = "PCI:2:0:0";
    # };
  };
}
