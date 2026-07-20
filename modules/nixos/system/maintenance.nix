{ ... }:

{
  # Keep store growth bounded by removing generations that are no longer recent.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  systemd.tmpfiles.rules = [
    # Keep the upstream daily cleanup timer; q preserves the Btrfs subvolume.
    "q /tmp 1777 root root 10d"
  ];
}
