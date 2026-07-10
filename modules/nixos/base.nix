{ pkgs, ... }:

{

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;

    # Numtide provides pre-built llm-agents.nix packages; keeping its cache here
    # avoids rebuilding Codex and other AI coding tools locally.
    extra-substituters = [
      "https://vicinae.cachix.org"
      "https://cache.numtide.com"
    ];
    extra-trusted-public-keys = [
      "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
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
