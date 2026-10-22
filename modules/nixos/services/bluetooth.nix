{ ... }:

{
  hardware.bluetooth = {
    enable = true;

    # Keep the controller usable after boot so keyboards, mice, and headphones
    # can reconnect without manually powering Bluetooth on each login.
    powerOnBoot = true;

    # Enables newer BlueZ features such as battery reporting for supported
    # Bluetooth peripherals.
    settings.General.Experimental = true;
  };

  # Provides blueman-manager and D-Bus integration for pairing devices from
  # Niri sessions without requiring a full desktop environment.
  services.blueman.enable = true;
}
