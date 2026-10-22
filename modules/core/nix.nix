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

      # Prefer caches for the core desktop components before the default NixOS
      # cache (priority 40), then try the narrower feature-specific caches.  Set
      # every priority explicitly because caches without one otherwise default
      # to priority 0 and unexpectedly take precedence over cache.nixos.org.
      # TODO(rewrite): move each cache into the feature module that needs it.
      extra-substituters = [
        "https://noctalia.cachix.org?priority=20"
        "https://vicinae.cachix.org?priority=30"
        # Numtide provides pre-built llm-agents.nix packages such as Codex.
        "https://cache.numtide.com?priority=50"
        # Use the addon's official cache instead of rebuilding sherpa-onnx locally.
        "https://fcitx5-vinput.cachix.org?priority=60"
        # CUDA-enabled packages are not built by the main NixOS Hydra cache.
        "https://cache.nixos-cuda.org?priority=70"
      ];
      extra-trusted-public-keys = [
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        "fcitx5-vinput.cachix.org-1:XpX3AA6+dDIX4qJhb1QM7sbTwX6/qSlGvW8Z5NK6XdU="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
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
