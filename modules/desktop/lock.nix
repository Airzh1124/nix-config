{
  config,
  lib,
  paths,
  pkgs,
  ...
}:

let
  niri = lib.getExe config.programs.niri.package;
  lock = "${lib.getExe pkgs.swaylock} -f";
in
{
  # swaylock authenticates through its own PAM service.
  security.pam.services.swaylock = { };

  hm.programs.swaylock = {
    enable = true;
    settings = {
      ignore-empty-password = true;
      show-failed-attempts = true;

      image = "${paths.assets.wallpapers.nixos}";
      scaling = "fill";
    };
  };

  hm.services.swayidle = {
    enable = true;

    # -w 可以让 before-sleep 等命令执行完再继续睡眠（模块默认值，显式写出）。
    extraArgs = [ "-w" ];

    timeouts = [
      # 5 分钟后锁屏
      {
        timeout = 300;
        command = lock;
      }

      # 7 分钟后关闭显示器，有输入时重新点亮
      {
        timeout = 420;
        command = "${niri} msg action power-off-monitors";
        resumeCommand = "${niri} msg action power-on-monitors";
      }

      # 暂时停用自动挂起：NVIDIA nvidia-modeset 在睡眠恢复后可能卡死于
      # DIFR prefetch，并永久持有 nvkms 锁导致整个桌面失去响应。
      # 等待 NVIDIA 上游 issue #1167 / PR #1192 的修复进入正式驱动后再恢复。
      # {
      #   timeout = 1800;
      #   command = "${pkgs.systemd}/bin/systemctl suspend";
      # }
    ];

    events = {
      # 睡眠前先锁屏
      "before-sleep" = lock;

      # 收到 logind lock 信号时锁屏
      "lock" = lock;
    };
  };
}
