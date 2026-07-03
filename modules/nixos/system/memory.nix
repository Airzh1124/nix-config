{ ... }:

{
  swapDevices = [
    {
      device = "/swapfile";
      size = 32 * 1024;
    }
  ];

  services.earlyoom.enable = true;

  nix.settings = {
    max-jobs = 8;
    cores = 0;
  };
}
