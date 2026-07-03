{ pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = [ pkgs.fcitx5-rime ];

    # Set boolean i18n.inputMethod.fcitx5.waylandFrontend to true to suppress warnings about environment variables. 
    # https://wiki.nixos.org/wiki/Fcitx5
    fcitx5.waylandFrontend = true;
  };
}
