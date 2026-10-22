{ ... }:

let
  # Built-in Wi-Fi card; NetworkManager's shared profile turns it into a hotspot.
  hotspotInterface = "wlp129s0f0";
in
{
  # NetworkManager's shared Wi-Fi profile provides DHCP/DNS for hotspot clients.
  networking.firewall.interfaces.${hotspotInterface} = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [
      53
      67
    ];
  };

  # Allow the wired connection to be forwarded to the Wi-Fi hotspot.
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  # Mihomo's auto-redirect uses a random TCP port; REDIRECT connections are
  # tracked as DNAT. Only allow redirected IPv4 hotspot traffic, not direct
  # access to local services.
  networking.firewall.extraCommands = ''
    iptables -w -A nixos-fw -i ${hotspotInterface} -s 10.42.0.0/24 \
      -p tcp -m conntrack --ctstate DNAT -j nixos-fw-accept
  '';
}
