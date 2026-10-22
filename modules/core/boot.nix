{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      # The ESP is only 511 MB. Generations share identical initrds and
      # kernels, but each distinct one costs ~43 MB (initrd) or ~14 MB
      # (kernel), and the installer copies new files before deleting old ones.
      # Six generations fit even when they span several kernel versions; a full
      # ESP aborts the install, so lower this if /boot gets close to full.
      # Older system generations remain in the Nix profile until nh-clean.
      configurationLimit = 6;
      # The boot menu editor allows passing init=/bin/sh without a password.
      editor = false;
    };
  };
}
