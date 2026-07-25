{ inputs, pkgs, ... }:

{
  # Packages without meaningful Home Manager modules live here.
  # Program-specific configuration belongs in home/programs.
  home.packages = with pkgs; [
    # Desktop applications
    nautilus
    # Use ONLYOFFICE for Microsoft Office documents with stronger OOXML compatibility.
    onlyoffice-desktopeditors
    telegram-desktop
    mpv
    # The package ships its own D-Bus-activatable user service; Fcitx5 addon
    # discovery is configured separately in the system input-method wrapper.
    inputs.fcitx5-vinput.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Everyday CLI utilities
    cowsay
    fd
    file
    fzf
    gawk
    gnused
    ripgrep
    tree
    which
    zoxide

    # Archive and compression tools
    gnutar
    p7zip
    unar
    unzip
    xz
    zip
    zstd

    # File previews and media metadata, used by tools such as yazi.
    ffmpegthumbnailer
    imagemagick
    poppler-utils

    # Security and crypto tools
    gnupg

    # System monitoring
    iftop
    iotop
    lm_sensors
    sysstat

    # Debugging and inspection
    lsof
    ltrace
    strace

    # Hardware and network inspection
    ethtool
    pciutils
    usbutils

    # Development tools
    uv

    # Cloud and file sync tools
    rclone


  #Github CLI tools
    gh
  ];
}
