{ pkgs, ... }:

let
  # rog-control-center loads libnvidia-ml.so.1 with dlopen() for the dGPU
  # temperature and usage, but the nixpkgs build has no rpath to the driver
  # library directory, so those fields stay empty. Wrap only this binary
  # (symlinkJoin avoids rebuilding asusctl) and remove this once nixpkgs does.
  asusctl = pkgs.symlinkJoin {
    inherit (pkgs.asusctl)
      name
      pname
      version
      meta
      ;
    paths = [ pkgs.asusctl ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/rog-control-center \
        --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib
    '';
  };
in
{
  services.asusd = {
    enable = true;
    # Use the wrapped package so the tray, desktop entry and CLI launch the
    # same rog-control-center that can find NVML.
    package = asusctl;
  };

  # asus-shutdown waits for a real shutdown request and otherwise ignores
  # SIGTERM, which makes every NixOS switch leave it stuck for 90 seconds.
  # Keep its normal 45-second graceful window, then let systemd clean it up.
  systemd.services.asus-shutdown = {
    path = [ pkgs.kmod ];
    serviceConfig.SendSIGKILL = true;
  };
}
