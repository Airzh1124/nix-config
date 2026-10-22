{ config, lib, ... }:

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

  # CUDA-enabled packages (btop, OBS) are not built by the main NixOS
  # Hydra cache; priority 70 keeps it behind cache.nixos.org.
  nix.settings = {
    extra-substituters = [ "https://cache.nixos-cuda.org?priority=70" ];
    extra-trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    nvidiaPersistenced = true;
    powerManagement.enable = true;
    # nvidia-powerd lifts the GPU power limit above the 65 W base (firmware
    # allows up to 115 W TGP + 25 W Dynamic Boost on this laptop).
    dynamicBoost.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  # The main configuration is dedicated-GPU mode: NVIDIA drives the internal
  # panel directly, so PRIME offload stays disabled.
  specialisation = {
    # Hybrid mode keeps the desktop on Intel and wakes NVIDIA only for
    # explicitly offloaded applications such as Steam.
    nvidia-hybrid.configuration.hardware.nvidia = {
      prime = {
        offload.enable = true;
        offload.enableOffloadCmd = true;
        # Bus IDs are host-specific and set in hosts/<host>.
      };

      # nvidia-persistenced keeps the device open, which prevents the dGPU
      # from ever entering runtime D3 and defeats the point of hybrid mode.
      nvidiaPersistenced = lib.mkForce false;

      # Let the driver power the idle dGPU down (RTD3). This requires PRIME
      # offload, which is enabled above, and a Turing or newer GPU.
      powerManagement.finegrained = true;
    };

    # Integrated mode physically disables the dGPU. Keep the matching boot
    # entry free of every NVIDIA module and service so the driver never probes
    # a device which the firmware has powered off.
    intel-igpu.configuration = {
      services.xserver.videoDrivers = lib.mkForce [ "modesetting" ];
      boot.blacklistedKernelModules = [
        "nvidia"
        "nvidia_drm"
        "nvidia_modeset"
        "nvidia_uvm"
      ];
      hardware.nvidia = {
        modesetting.enable = lib.mkForce false;
        nvidiaSettings = lib.mkForce false;
        nvidiaPersistenced = lib.mkForce false;
        powerManagement.enable = lib.mkForce false;
        dynamicBoost.enable = lib.mkForce false;
        prime.offload.enable = lib.mkForce false;
        prime.offload.enableOffloadCmd = lib.mkForce false;
      };
    };
  };
}
