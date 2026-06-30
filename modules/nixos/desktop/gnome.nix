{ ... }:

{
  services.xserver.enable = false;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
}
