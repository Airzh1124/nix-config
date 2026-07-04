{ ... }:

{
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
    priority = 100;
  };

  services.earlyoom.enable = true;
}
