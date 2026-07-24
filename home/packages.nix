{ inputs, pkgs, ... }:

{
  # Packages without meaningful Home Manager modules live here.
  # Program-specific configuration belongs in home/programs.
  home.packages = with pkgs; [
    # Desktop applications
    nautilus
    # Wrap the final AppImage launcher because overriding its fixup phase does
    # not affect the bubblewrap executable produced by appimageTools.
    (symlinkJoin {
      name = "wechat-with-fcitx";
      paths = [ wechat ];
      nativeBuildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/wechat \
          --run '${xrdb}/bin/xrdb -merge "$HOME/.Xresources"' \
          --set GTK_IM_MODULE fcitx \
          --set QT_IM_MODULE fcitx \
          --set XMODIFIERS @im=fcitx \
          --prefix QT_PLUGIN_PATH : "${libsForQt5.fcitx5-qt}/${libsForQt5.qtbase.qtPluginPrefix}"
      '';
    })
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
