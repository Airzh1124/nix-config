{ config, pkgs, ... }:

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

  gpuMode = pkgs.writeShellApplication {
    name = "rog-gpu-mode";
    runtimeInputs = [
      config.services.asusd.package
      pkgs.systemd
    ];
    text = ''
      usage() {
        printf '%s\n' \
          "usage: rog-gpu-mode {dedicated|hybrid|integrated}" \
          "  dedicated   NVIDIA 独显直连" \
          "  hybrid      Intel 显示，NVIDIA 按需渲染" \
          "  integrated  仅使用 Intel，关闭 NVIDIA"
      }

      system_profile=/nix/var/nix/profiles/system

      case "''${1:-}" in
        dedicated)
          target="$system_profile"
          settings=(dgpu_disable 0 gpu_mux_mode 0)
          ;;
        hybrid)
          target="$system_profile/specialisation/nvidia-hybrid"
          settings=(dgpu_disable 0 gpu_mux_mode 1)
          ;;
        integrated)
          target="$system_profile/specialisation/intel-igpu"
          settings=(gpu_mux_mode 1 dgpu_disable 1)
          ;;
        -h|--help)
          usage
          exit 0
          ;;
        *)
          usage >&2
          exit 2
          ;;
      esac

      if (( EUID != 0 )); then
        echo "rog-gpu-mode must run as root" >&2
        exit 1
      fi

      switch="$target/bin/switch-to-configuration"
      if [[ ! -x "$switch" ]]; then
        echo "GPU boot profile is unavailable: $target" >&2
        exit 1
      fi

      asusctl armoury set "''${settings[0]}" "''${settings[1]}"
      asusctl armoury set "''${settings[2]}" "''${settings[3]}"
      "$switch" boot
      systemctl reboot
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

  # Change the firmware attributes and matching boot profile as one operation;
  # starting NVIDIA against a firmware-disabled dGPU wedges the driver.
  environment.systemPackages = [ gpuMode ];
}
