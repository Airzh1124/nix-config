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

      # Feature modules add their own caches next to the inputs they cache.
      # Always set `?priority=`: caches without one default to priority 0 and
      # unexpectedly take precedence over cache.nixos.org (40).
      # TODO(rewrite): move to the llm-agents feature module.
      extra-substituters = [
        # Numtide provides pre-built llm-agents.nix packages such as Codex.
        "https://cache.numtide.com?priority=50"
      ];
      extra-trusted-public-keys = [
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
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
