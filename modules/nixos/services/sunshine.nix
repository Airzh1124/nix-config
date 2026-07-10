{ ... }:

{
  services.sunshine = {
    enable = true;

    # Sunshine runs as a user service once the graphical session is available.
    # Keep this explicit because greetd starts the Niri session directly.
    autoStart = false;

    # Moonlight needs Sunshine's TCP/UDP ports, and Avahi discovery is enabled
    # by the module for finding this host on the local network.
    openFirewall = true;

    # Niri + NVIDIA uses DRM/KMS capture; this capability is required for the
    # Sunshine binary to access the display without running the service as root.
    capSysAdmin = true;
  };
}
