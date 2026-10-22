{ pkgs, ... }:

{
  # Plain utilities with no related feature module, grouped by purpose.
  hm.home.packages = with pkgs; [
    # Clipboard
    wl-clipboard

    # Communication
    # 64Gram replaces Telegram Desktop for its screenshot mode, which masks chat
    # names while recording. Both install a `Telegram` binary, so keep only one.
    _64gram

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
    # Provide bwrap for running commands in isolated user namespaces.
    bubblewrap
    gnupg

    # Debugging and inspection
    lsof
    ltrace
    strace

    # Hardware and network inspection
    ethtool
    iw
    pciutils
    usbutils

    # Language runtimes for ad-hoc scripts; projects use devShells.
    nodejs
    python3
    uv

    # Cloud and file sync tools
    rclone
  ];
}
