{
  lib,
  paths,
  pkgs,
  ...
}:

let
  safeeyes = pkgs.safeeyes.overridePythonAttrs (old: {
    # Smart Pause needs pywayland for ext-idle-notify on niri; nixpkgs leaves it optional.
    dependencies = old.dependencies ++ old.optional-dependencies.wayland;

    # pywayland 0.4.19 flattened protocol modules; fixed upstream in 3.5.1 (slgobinath/safeeyes#906).
    postPatch =
      (old.postPatch or "")
      + lib.optionalString (lib.versionOlder old.version "3.5.1") ''
        substituteInPlace safeeyes/plugins/smartpause/ext_idle_notify.py \
          --replace-fail "pywayland.protocol.wayland.wl_seat" "pywayland.protocol.wayland"
      ''
      # GetLayout must root its reply at the requested id, or Noctalia caches a submenu as the root menu.
      + ''
        substituteInPlace safeeyes/plugins/trayicon/plugin.py \
          --replace-fail '(0, {"children-display"' '(parent_id, {"children-display"'
      '';

    # The audible alert plays via pw-play; the upstream wrapper only ships aplay.
    preFixup = (old.preFixup or "") + ''
      makeWrapperArgs+=(
        --prefix PATH : ${lib.makeBinPath [ pkgs.pipewire ]}
      )
    '';
  });
in
{
  # A plain unit instead of HM's services.safeeyes, whose ExecStart ignores its package option.
  systemd.user.services.safeeyes = {
    description = "Safe Eyes";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = lib.getExe safeeyes;
      Restart = "on-failure";
      RestartSec = 3;
    };
  };

  hm =
    { config, ... }:
    {
      # Safe Eyes rewrites its config on startup and from the GUI, so link it writable.
      xdg.configFile."safeeyes/safeeyes.json" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink paths.user.safeeyesConfigFile;
      };
    };
}
