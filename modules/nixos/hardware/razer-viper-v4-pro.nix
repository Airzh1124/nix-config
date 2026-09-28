{ ... }:

{
  # The Razer web configurator uses WebHID and needs access to hidraw.
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="1532", ATTRS{idProduct}=="00e6", MODE:="0660", GROUP:="users"
  '';
}
