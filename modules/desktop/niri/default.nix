{
  config,
  lib,
  paths,
  pkgs,
  ...
}:

let
  niri = config.programs.niri.package;
in
{
  programs.niri.enable = true;

  # Niri 官方推荐通过 niri-session / display manager 作为完整 session 启动。
  # NixOS Wiki 也提到，配合 Home Manager 时建议关掉 niri.service 默认 PATH，
  # 让它继承 niri-session 准备好的用户环境。
  systemd.user.services.niri.enableDefaultPath = false;

  # Electron / Chromium 系应用走 Wayland。
  # 不要全局设置 GDK_BACKEND，Niri 官方文档说这会破坏 screencast portal。
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # Niri 不是完整桌面环境，所以需要补 portal。
  # gtk: 基础 fallback portal / 文件选择器
  # gnome: Niri 官方文档说明 screencasting 需要它
  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];

    # Match portal backend selection to the niri desktop name. Keeping this under
    # config.niri avoids relying on xdg-desktop-portal's generic common fallback.
    # FileChooser stays on gtk so Nautilus remains explicitly managed by Home Manager
    # instead of being coupled to the GNOME portal implementation.
    config.niri = {
      default = [
        "gnome"
        "gtk"
      ];
      "org.freedesktop.impl.portal.Access" = [ "gtk" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      "org.freedesktop.impl.portal.Notification" = [ "gtk" ];
      "org.freedesktop.impl.portal.RemoteDesktop" = [ "gnome" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
      "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };
  };

  # root 权限弹窗、系统设置类应用需要 polkit。
  # 认证 agent 本身后面可以放 Home Manager 启动，例如 Noctalia / polkit-gnome / kde polkit。
  security.polkit.enable = true;

  services.libinput.enable = true;

  # 只放 Niri 必需或强相关的系统级 runtime。
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];

  # The KDL files stay in the repository so niri's live reload picks up edits
  # without a rebuild. `text` is `lines`, so hosts can append their own includes.
  hm.xdg.configFile."niri/config.kdl".text = ''
    include "${paths.user.niriConfigDirectory}/config.kdl"
  '';

  # niri's built-in screenshot has no annotation, so Satty edits the capture it
  # left on the clipboard (see the Mod+Shift+A bind in binds.kdl).
  hm.programs.satty = {
    enable = true;
    settings.general = {
      # Boxes are the most common annotation; other tools stay one click away.
      initial-tool = "rectangle";
      # wl-copy keeps serving the image after Satty exits, unlike GTK's clipboard.
      copy-command = "wl-copy";
      early-exit = true;
      # Annotated copies sit next to niri's originals, told apart by the prefix.
      output-filename = "${paths.user.screenshotDirectory}/Annotated %Y-%m-%d %H-%M-%S.png";
    };
    # Satty draws text with only the fonts named here and ignores fontconfig
    # fallback, so Chinese needs an explicit CJK fallback (fonts.nix installs it).
    settings.font.fallback = [ "Noto Sans CJK SC" ];
  };

  # greetd starts this file (paths.user.waylandSessionFile), so the login
  # manager does not hard-code a compositor.
  hm.home.file.".wayland-session" = {
    source = lib.getExe' niri "niri-session";
    executable = true;
  };
}
