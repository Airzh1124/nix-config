{ ... }:

let
  # Built-in Wi-Fi card; NetworkManager's shared profile turns it into a hotspot.
  hotspotInterface = "wlp129s0f0";
in
{
  # NetworkManager's shared Wi-Fi profile provides DHCP/DNS for hotspot clients.
  # TCP 8000: course notes served to the iPad (python3 -m http.server on 10.42.0.1).
  networking.firewall.interfaces.${hotspotInterface} = {
    allowedTCPPorts = [
      53
      8000
    ];
    allowedUDPPorts = [
      53
      67
    ];
  };

  # Hotspot clients bypass mihomo (tun.exclude-interface), but mihomo's
  # dns-hijack still answers every DNS query this host sends, so dnsmasq would
  # relay fake-ip (198.18.x.x) answers the clients can't reach. Hand clients a
  # public resolver over DHCP instead; their queries are forwarded straight out.
  # NetworkManager only passes this --conf-dir to dnsmasq when it exists.
  environment.etc."NetworkManager/dnsmasq-shared.d/hotspot-dns.conf".text = ''
    dhcp-option=option:dns-server,223.5.5.5,119.29.29.29
  '';

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
