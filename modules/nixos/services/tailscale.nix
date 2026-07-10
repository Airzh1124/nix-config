{ lib, ... }:

{
  services.tailscale = {
    enable = true;

    # 允许 WireGuard UDP 端口，便于节点之间建立直连；Tailscale 会验证隧道流量。
    openFirewall = true;
  };

  # 默认不随系统启动；如需开机自启，将 [] 改为 [ "multi-user.target" ]。
  systemd.services.tailscaled.wantedBy = lib.mkForce [ ];
}
