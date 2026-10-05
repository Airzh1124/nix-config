{ paths, pkgs, ... }:

{
  services.mihomo = {
    enable = true;
    package = pkgs.mihomo;

    # TUN mode needs system-level capabilities; proxy rules and secrets stay outside the flake.
    tunMode = true;
    configFile = paths.user.mihomoConfigFile;
  };

  # auto-redirect uses a random TCP port; REDIRECT connections are tracked as DNAT.
  # Only allow redirected IPv4 hotspot traffic, not direct access to local services.
  networking.firewall.extraCommands = ''
    iptables -w -A nixos-fw -i wlp129s0f0 -s 10.42.0.0/24 \
      -p tcp -m conntrack --ctstate DNAT -j nixos-fw-accept
  '';
}
