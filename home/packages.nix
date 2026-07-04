{ pkgs, ... }:

{
  # Packages without meaningful Home Manager modules live here.
  # Program-specific configuration belongs in home/programs.
  home.packages = with pkgs; [
    zip
    xz
    unzip
    p7zip

    (btop.override { cudaSupport = true; })
    iotop
    iftop

    strace
    ltrace
    lsof

    fuzzel

    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
    ripgrep

    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils

    # An extremely fast Python package and project manager, written in Rust.
    uv
  ];
}
