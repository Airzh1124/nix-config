{ ... }:

{
  # ATK HUB configures the keyboards through WebHID. The kernel creates their
  # hidraw interfaces as root-only by default, so grant the local users group
  # access while keeping the rules limited to each keyboard's USB VID/PID.
  services.udev.extraRules = ''
    # RS6 Air
    KERNEL=="hidraw*", ATTRS{idVendor}=="373b", ATTRS{idProduct}=="11d0", MODE:="0660", GROUP:="users"

    # RS6 Air generates spurious remote-wakeup events during s2idle. Match the
    # USB device by hardware identity so the rule is independent of its port.
    ACTION=="add|change", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="373b", ATTR{idProduct}=="11d0", TEST=="power/wakeup", ATTR{power/wakeup}="disabled"

    # RS7 Air PIKACHU Edition. Its remote wakeup stays enabled until it shows
    # the same spurious s2idle wakeups as the RS6 Air.
    KERNEL=="hidraw*", ATTRS{idVendor}=="373b", ATTRS{idProduct}=="1318", MODE:="0660", GROUP:="users"
    # Firmware updates reboot it into a separate "RS7 Upgrade" device that the
    # web updater also reaches over WebHID.
    KERNEL=="hidraw*", ATTRS{idVendor}=="373b", ATTRS{idProduct}=="21e3", MODE:="0660", GROUP:="users"
  '';
}
