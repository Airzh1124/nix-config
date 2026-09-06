{ inputs, pkgs, ... }:

{
  # Packages without meaningful Home Manager modules live here.
  # Program-specific configuration belongs in home/programs.
  home.packages = with pkgs; [
    # File management
    nautilus
    wl-clipboard

    # Office and document tools
    onlyoffice-desktopeditors
    poppler-utils

    # Image editing and conversion
    imagemagick
    pinta


    # Media playback and previews
    ffmpegthumbnailer
    mpv

    # Communication
    telegram-desktop

    # Input methods
    # The package ships its own D-Bus-activatable user service; Fcitx5 addon
    # discovery is configured separately in the system input-method wrapper.
    inputs.fcitx5-vinput.packages.${pkgs.stdenv.hostPlatform.system}.default
    # Doubao IME streams Opus frames and loads this library at runtime.
    libopus

    # Shell navigation and search
    fd
    fzf
    ripgrep
    tree
    which
    zoxide

    # General command-line utilities
    cowsay
    file

    # Text processing
    gawk
    gnused

    # Archive and compression tools
    gnutar
    p7zip
    unar
    unzip
    xz
    zip
    zstd

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
    iw
    pciutils
    usbutils

    # Development tools
    gh
    inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi
    nodejs
    python3
    uv

    # Cloud and file sync tools
    rclone
  ];
}
