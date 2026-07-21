{ pkgs, ... }:

{

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;

    # Numtide provides pre-built llm-agents.nix packages; keeping its cache here
    # avoids rebuilding Codex and other AI coding tools locally.
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://vicinae.cachix.org"
      "https://cache.numtide.com"
      # Use the addon's official cache instead of rebuilding sherpa-onnx locally.
      "https://fcitx5-vinput.cachix.org"
      # CUDA-enabled packages are not built by the main NixOS Hydra cache.
      "https://cache.nixos-cuda.org"
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

  time.timeZone = "Asia/Shanghai";

  services.libinput.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
    openconnect
    brightnessctl
  ];

  system.stateVersion = "26.05";
}
