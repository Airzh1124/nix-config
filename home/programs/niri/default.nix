{ paths, ... }:

{
  xdg.configFile."niri/config.kdl".text = ''
    include "${paths.user.niriConfigDirectory}/config.kdl"
  '';
}
