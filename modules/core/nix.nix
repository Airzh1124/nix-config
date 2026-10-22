{ paths, ... }:

{
  nix = {
    # Builds and GC run in the background; keep the desktop responsive meanwhile.
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedClass = "idle";

    # Everything comes from the flake; legacy channels only cause confusion.
    channel.enable = false;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [ "@wheel" ];

      # Resolve flake references through this flake's lock, not the global registry.
      flake-registry = "";
      # The repository is usually dirty while iterating on a change.
      warn-dirty = false;
      # Fail over to the next substituter quickly when a cache is unreachable.
      connect-timeout = 5;
      log-lines = 50;

      # Free space automatically when a build is about to fill the disk.
      min-free = 5 * 1024 * 1024 * 1024;
      max-free = 10 * 1024 * 1024 * 1024;
    };
  };

  nixpkgs.config.allowUnfree = true;

  programs.nh = {
    enable = true;
    # NH_FLAKE points at the live checkout; nh picks `#rog` from the hostname.
    flake = paths.user.nixConfigDirectory;

    # Replaces nix.gc (the module asserts only one is enabled). Keep the previous
    # one-week window, and keep direnv's gcroots so project devShells survive.
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5 --no-gcroots";
    };
  };
}
