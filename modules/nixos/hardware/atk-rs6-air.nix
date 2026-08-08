{ ... }:

{
  # ATK HUB configures the keyboard through WebHID. The kernel creates its
  # hidraw interfaces as root-only by default, so grant the local users group
  # access while keeping the rule limited to this keyboard's USB VID/PID.
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="373b", ATTRS{idProduct}=="11d0", MODE:="0660", GROUP:="users"
  '';
}
