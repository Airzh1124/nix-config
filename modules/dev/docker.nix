{ username, ... }:

{
  virtualisation.docker = {
    enable = true;

    # 不开机自启；docker.socket 会在第一次执行 docker 命令时按需拉起守护进程。
    enableOnBoot = false;

    # 定期清理悬空镜像和停止的容器，避免练习靶场之类的镜像长期占用磁盘。
    autoPrune.enable = true;
  };

  # docker 组等同 root 权限，加入后免 sudo 使用 docker CLI。
  users.users.${username}.extraGroups = [ "docker" ];
}
