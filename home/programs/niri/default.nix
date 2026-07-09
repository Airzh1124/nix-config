{ config, ... }:

let
  niriConfigDir = "${config.home.homeDirectory}/nix-config/home/programs/niri/config";
in
{
  xdg.configFile."niri/config.kdl".text = ''
    include "${niriConfigDir}/config.kdl"
  '';
}