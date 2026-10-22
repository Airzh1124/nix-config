{ pkgs, ... }:

{
  # Niri 不自带桌面文件管理运行时；为 Nautilus 启用 GVfs。
  # 该模块会一并启用 udisks2、FUSE、D-Bus 与 MTP 支持。
  services.gvfs.enable = true;

  # Nautilus 启动时会连接 Tracker/LocalSearch；启用服务避免连接超时。
  services.gnome.localsearch.enable = true;

  hm.home.packages = [ pkgs.nautilus ];
}
