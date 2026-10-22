{ pkgs, ... }:

{
  time.timeZone = "Asia/Shanghai";

  networking.networkmanager.enable = true;

  # BBR keeps throughput up on lossy Wi-Fi and long-haul proxy links.
  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
    priority = 100;
  };

  services.earlyoom.enable = true;

  # Bound log and crash-dump growth on the laptop SSD.
  services.journald.settings.Journal = {
    SystemMaxUse = "1G";
    MaxRetentionSec = "14day";
  };

  systemd.tmpfiles.rules = [
    # Keep the upstream daily cleanup timer; q preserves the Btrfs subvolume.
    "q /tmp 1777 root root 10d"
    "d /var/lib/systemd/coredump 0755 root root 3d"
  ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
  ];

  system.stateVersion = "26.05";
}
