{ pkgs, ... }:

{
  services.mihomo = {
    enable = true;
    package = pkgs.mihomo;

    # TUN mode needs system-level capabilities; proxy rules and secrets stay outside the flake.
    tunMode = true;
    configFile = "/home/han/.config/mihomo/config.yaml";
  };
}
