{ pkgs, ... }:

{
  services.asusd.enable = true;

  # Noctalia reads the laptop battery state through UPower; without this
  # service its existing battery widget hides itself even when BAT0 exists.
  services.upower.enable = true;

  # Keep detailed PM messages enabled for the next suspend cycle so an
  # unexpected s2idle wakeup can be traced back to its IRQ or device.
  systemd.services.suspend-diagnostics = {
    description = "Enable suspend diagnostics";
    wantedBy = [ "sleep.target" ];
    before = [ "sleep.target" ];
    unitConfig.ConditionPathExists = "/sys/power/pm_debug_messages";
    serviceConfig.Type = "oneshot";
    script = ''
      echo 1 > /sys/power/pm_debug_messages
      echo 1 > /sys/power/pm_print_times

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
