{ ... }:

{
  # 放行 syncthing 的端口
  # https://docs.syncthing.net/users/firewall.html
  networking.firewall = {
    allowedTCPPorts = [ 22000 ];
    allowedUDPPorts = [
      22000
      21027
    ];
  };

  # Runs as a user service; devices and folders are managed from the web GUI.
  hm.services.syncthing = {
    enable = true;
    guiAddress = "127.0.0.1:8384";

    overrideDevices = false;
    overrideFolders = false;

    settings.options.urAccepted = -1;
  };
}
