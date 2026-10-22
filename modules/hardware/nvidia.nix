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

  # This laptop always runs in dedicated-GPU MUX mode: NVIDIA drives the
  # internal panel directly. The Hybrid and integrated boot profiles were
  # removed because each specialisation re-evaluates the whole system; do not
  # switch the MUX or disable the dGPU in rog-control-center without adding a
  # matching configuration back first.
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
}
