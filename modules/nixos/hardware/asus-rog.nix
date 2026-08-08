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

    if [ -r /sys/kernel/debug/wakeup_sources ]; then
      echo "suspend-diagnostics: wakeup sources with non-zero counters"
      ${pkgs.gawk}/bin/awk 'NR == 1 || $3 > 0 || $4 > 0 || $5 > 0' \
        /sys/kernel/debug/wakeup_sources
    else
      echo "suspend-diagnostics: wakeup_sources unavailable"
    fi
  '';
}
