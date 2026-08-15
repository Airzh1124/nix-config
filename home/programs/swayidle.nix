{ pkgs, ... }:

let
  swaylock = "${pkgs.swaylock}/bin/swaylock";
  niri = "${pkgs.niri}/bin/niri";
  systemctl = "${pkgs.systemd}/bin/systemctl";

  lock = "${swaylock} -f";
  powerOffMonitors = "${niri} msg action power-off-monitors";
  powerOnMonitors = "${niri} msg action power-on-monitors";
in
{
  services.swayidle = {
    enable = true;
    package = pkgs.swayidle;

    # 默认就是 [ "-w" ]，这里显式写出来。
    # -w 可以让 before-sleep 等命令执行完再继续睡眠。
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
        command = powerOffMonitors;
        resumeCommand = powerOnMonitors;
      }

      # 暂时停用自动挂起：NVIDIA nvidia-modeset 在睡眠恢复后可能卡死于
      # DIFR prefetch，并永久持有 nvkms 锁导致整个桌面失去响应。
      # 等待 NVIDIA 上游 issue #1167 / PR #1192 的修复进入正式驱动后再恢复。
      # {
      #   timeout = 1800;
      #   command = "${systemctl} suspend";
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
