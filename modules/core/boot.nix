{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      # The ESP is only 511 MB and every generation needs three ~43 MB initrds
      # (main + two GPU-mode specialisations), plus a 14 MB kernel per kernel
      # version; more generations than this fill /boot and break installs.
      # Older system generations remain in the Nix profile until nh-clean.
      configurationLimit = 3;
      # The boot menu editor allows passing init=/bin/sh without a password.
      editor = false;
    };
  };
}
