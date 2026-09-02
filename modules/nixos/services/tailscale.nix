{ ... }:

{
  services.tailscale = {
    enable = true;

    # 允许 WireGuard UDP 端口，便于节点之间建立直连；Tailscale 会验证隧道流量。
    openFirewall = true;
  };
}
