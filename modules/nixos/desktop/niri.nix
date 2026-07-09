{ config, pkgs, ... }:

{
  programs.niri = {
    enable = true;
  };

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

    # 避免 xdg-desktop-portal-gnome 默认调用 Nautilus 做文件选择器。
    # 你目前结构里没有 Nautilus，也没必要为了文件选择器引入它。
    config.niri = {
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    };
  };

  # root 权限弹窗、系统设置类应用需要 polkit。
  # 认证 agent 本身后面可以放 Home Manager 启动，例如 Noctalia / polkit-gnome / kde polkit。
  security.polkit.enable = true;

  # 锁屏 PAM。真正的 swaylock / gtklock 包后面放 Home Manager。
  security.pam.services.swaylock = {};

  # 只放 Niri 必需或强相关的系统级 runtime。
  # 不放 kitty / fuzzel / mako / swayidle / screenshot / Noctalia。
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];
}