{ config, pkgs, ... }:

{
  # Plain utilities with no related feature module, grouped by purpose.
  hm.home.packages = with pkgs; [
    # Clipboard
    wl-clipboard

    # Shell navigation and search
    fd
    ripgrep
    tree
    which

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
    # CUDA backend only when the NVIDIA driver is loaded; OpenCL otherwise.
    (hashcat.override { cudaSupport = config.hardware.nvidia.enabled; })

    # Language runtimes for ad-hoc scripts; projects use devShells.
    nodejs
    python3
    uv

    # Cloud and file sync tools
    rclone
  ];
}
