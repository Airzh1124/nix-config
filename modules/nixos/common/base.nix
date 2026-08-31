{ pkgs, ... }:

{

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;

    # Prefer caches for the core desktop components before the default NixOS
    # cache (priority 40), then try the narrower feature-specific caches.  Set
    # every priority explicitly because caches without one otherwise default
    # to priority 0 and unexpectedly take precedence over cache.nixos.org.
    extra-substituters = [
      "https://noctalia.cachix.org?priority=20"
      "https://vicinae.cachix.org?priority=30"
      # Numtide provides pre-built llm-agents.nix packages such as Codex.
      "https://cache.numtide.com?priority=50"
      # Use the addon's official cache instead of rebuilding sherpa-onnx locally.
      "https://fcitx5-vinput.cachix.org?priority=60"
      # CUDA-enabled packages are not built by the main NixOS Hydra cache.
      "https://cache.nixos-cuda.org?priority=70"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "fcitx5-vinput.cachix.org-1:XpX3AA6+dDIX4qJhb1QM7sbTwX6/qSlGvW8Z5NK6XdU="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openconnect
  ];

  # NetworkManager's shared Wi-Fi profile provides DHCP/DNS for hotspot clients.
  networking.firewall.interfaces."wlp129s0f0" = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 67 ];
  };

  # Allow the wired connection to be forwarded to the Wi-Fi hotspot.
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  time.timeZone = "Asia/Shanghai";

  services.libinput.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    openconnect
    brightnessctl
  ];

  system.stateVersion = "26.05";
}
