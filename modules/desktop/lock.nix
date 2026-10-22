{
  config,
  lib,
  paths,
  pkgs,
  username,
  ...
}:

let
  niri = lib.getExe config.programs.niri.package;
  swaylock = lib.getExe pkgs.swaylock;
  lock = "${swaylock} -f";

  # Marks the boot-time autologin session so only it gets locked at startup;
  # $XDG_RUNTIME_DIR is wiped once all of the user's sessions end, and a later
  # tuigreet login (which already asked for the password) finds no marker.
  lockMarker = ''"$XDG_RUNTIME_DIR/lock-at-login"'';

  autologinSession = pkgs.writeShellScript "autologin-wayland-session" ''
    touch ${lockMarker}
    exec ${paths.user.waylandSessionFile}
  '';

  lockAtLogin = pkgs.writeShellScript "lock-at-login" ''
    if [ -e ${lockMarker} ]; then
      rm ${lockMarker}
      exec ${swaylock}
    fi
  '';
in
{
  # Boot straight into the desktop and lock it at once, so swaylock doubles as
  # the login screen.
  services.greetd.settings.initial_session = {
    # Scope the class to the graphical child; setting it globally would also
    # override pam_systemd's manager class for user@.service.
    command = "${lib.getExe' pkgs.coreutils "env"} XDG_SESSION_CLASS=user ${autologinSession}";
    user = username;
  };

  # niri implements ext-session-lock, so the screen stays locked even if
  # swaylock crashes. mkBefore spawns it ahead of the shell and launcher.
  hm.xdg.configFile."niri/config.kdl".text = lib.mkBefore ''
    spawn-at-startup "${lockAtLogin}"
  '';

  # gkr-pam's auth step unlocks the already-running keyring with the password
  # typed into swaylock; autologin itself starts the keyring locked.
  security.pam.services.swaylock.enableGnomeKeyring = true;

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
