{ pkgs, ... }:

{
  # Packages without meaningful Home Manager modules live here.
  # Program-specific configuration belongs in home/programs.
  home.packages = with pkgs; [
    zip
    xz
    unzip
    p7zip

    btop
    iotop
    iftop

    strace
    ltrace
    lsof

    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils
  ];
}
