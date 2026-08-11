{ ... }:

{
  # ATK HUB configures the keyboard through WebHID. The kernel creates its
  # hidraw interfaces as root-only by default, so grant the local users group
  # access while keeping the rule limited to this keyboard's USB VID/PID.
  services.udev.extraRules = ''
    KERNEL=="hidraw*", ATTRS{idVendor}=="373b", ATTRS{idProduct}=="11d0", MODE:="0660", GROUP:="users"

    # RS6 Air generates spurious remote-wakeup events during s2idle. Match the
    # USB device by hardware identity so the rule is independent of its port.
    ACTION=="add|change", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="373b", ATTR{idProduct}=="11d0", TEST=="power/wakeup", ATTR{power/wakeup}="disabled"
  '';
}
