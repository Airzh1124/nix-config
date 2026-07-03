{ ... }:

{
  # 放行 syncthing 的端口
  # https://docs.syncthing.net/users/firewall.html
  networking.firewall = {
    allowedTCPPorts = [ 22000 ];
    allowedUDPPorts = [ 22000 21027 ];
  };
}
