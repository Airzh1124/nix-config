{ ... }:

{
  # The Razer web configurator uses WebHID/WebUSB and needs access to both
  # the HID interfaces and the parent USB device.
  services.udev.extraRules = ''
    SUBSYSTEM=="hidraw", KERNEL=="hidraw*", ATTRS{idVendor}=="1532", ATTRS{idProduct}=="00e6", MODE:="0660", GROUP:="users", TAG+="uaccess"
    SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTR{idVendor}=="1532", ATTR{idProduct}=="00e6", MODE:="0660", GROUP:="users", TAG+="uaccess"
  '';
}
