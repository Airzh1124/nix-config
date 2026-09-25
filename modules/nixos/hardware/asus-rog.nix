{ config, pkgs, ... }:

let
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
  services.asusd.enable = true;

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

  # Noctalia reads the laptop battery state through UPower; without this
  # service its existing battery widget hides itself even when BAT0 exists.
  services.upower.enable = true;

  # Keep detailed PM messages enabled for the next suspend cycle so an
  # unexpected s2idle wakeup can be traced back to its IRQ or device.
  systemd.services.suspend-diagnostics = {
    description = "Enable suspend diagnostics and ACPI wake tracing";
    wantedBy = [ "sleep.target" ];
    before = [ "sleep.target" ];
    unitConfig.ConditionPathExists = "/sys/power/pm_debug_messages";
    serviceConfig.Type = "oneshot";
    script = ''
      echo 1 > /sys/power/pm_debug_messages
      echo 1 > /sys/power/pm_print_times

      # Trace the GPE6B AML handler only during the suspend cycle. Its nested
      # calls cover the PCIe and PCH wake paths without globally tracing ACPI.
      trace_parameters=/sys/module/acpi/parameters
      if [ -w "$trace_parameters/trace_debug_layer" ] \
        && [ -w "$trace_parameters/trace_debug_level" ] \
        && [ -w "$trace_parameters/trace_method_name" ] \
        && [ -w "$trace_parameters/trace_state" ]; then
        if echo 0x80 > "$trace_parameters/trace_debug_layer" \
          && echo 0x10 > "$trace_parameters/trace_debug_level" \
          && printf '%s\n' '\_GPE._L6B' > "$trace_parameters/trace_method_name" \
          && echo opcode > "$trace_parameters/trace_state"; then
          echo "suspend-diagnostics: tracing ACPI method \\_GPE._L6B"
        else
          echo "suspend-diagnostics: failed to enable ACPI method tracing"
          echo disable > "$trace_parameters/trace_state" 2>/dev/null || true
        fi
      else
        echo "suspend-diagnostics: ACPI method tracing unavailable"
      fi

      # Store a per-cycle baseline so resume logging can identify exactly
      # which ACPI GPE counter changed while the system was suspending.
      if [ -d /sys/firmware/acpi/interrupts ]; then
        : > /run/suspend-diagnostics-gpe-before
        for gpe_file in /sys/firmware/acpi/interrupts/gpe[0-9A-F][0-9A-F]; do
          read -r count _ < "$gpe_file"
          echo "''${gpe_file##*/} $count" >> /run/suspend-diagnostics-gpe-before
        done
      fi
    '';
  };

  # Capture volatile wakeup information immediately after resume; these
  # sysfs/debugfs values would otherwise be lost at the next reboot.
  powerManagement.resumeCommands = ''
    trace_state=/sys/module/acpi/parameters/trace_state
    if [ -w "$trace_state" ] && echo disable > "$trace_state"; then
      echo "suspend-diagnostics: ACPI method tracing disabled"
    else
      echo "suspend-diagnostics: unable to disable ACPI method tracing"
    fi

    echo "suspend-diagnostics: resume wakeup snapshot"

    if wake_irq="$(${pkgs.coreutils}/bin/cat /sys/power/pm_wakeup_irq 2>/dev/null)"; then
      echo "suspend-diagnostics: pm_wakeup_irq=$wake_irq"
    else
      echo "suspend-diagnostics: pm_wakeup_irq unavailable"
    fi

    if [ -r /run/suspend-diagnostics-gpe-before ]; then
      echo "suspend-diagnostics: ACPI GPE counter deltas"
      gpe_delta_found=0

      while read -r gpe_name before_count; do
        gpe_file="/sys/firmware/acpi/interrupts/$gpe_name"
        [ -r "$gpe_file" ] || continue
        read -r after_count state < "$gpe_file"

        if [ "$after_count" -gt "$before_count" ]; then
          delta=$((after_count - before_count))
          echo "suspend-diagnostics: $gpe_name delta=$delta count=$after_count state=$state"
          gpe_delta_found=1
        fi
      done < /run/suspend-diagnostics-gpe-before

      if [ "$gpe_delta_found" -eq 0 ]; then
        echo "suspend-diagnostics: no ACPI GPE counter changed"
      fi
    else
      echo "suspend-diagnostics: ACPI GPE baseline unavailable"
    fi

    if [ -r /sys/kernel/debug/wakeup_sources ]; then
      echo "suspend-diagnostics: wakeup sources with non-zero counters"
      ${pkgs.gawk}/bin/awk 'NR == 1 || $3 > 0 || $4 > 0 || $5 > 0' \
        /sys/kernel/debug/wakeup_sources
    else
      echo "suspend-diagnostics: wakeup_sources unavailable"
    fi
  '';
}
