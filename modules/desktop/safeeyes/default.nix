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

        # 3.5.0's zh_CN lacks the newer break names; 3.5.1 translates them all.
        cp ${
          pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/slgobinath/safeeyes/v3.5.1/safeeyes/config/locale/zh_CN/LC_MESSAGES/safeeyes.po";
            hash = "sha256-MmmFaK0oY/vcErJr7zyOBYIjz1sMbSBGU5WmH86+SXQ=";
          }
        } safeeyes/config/locale/zh_CN/LC_MESSAGES/safeeyes.po
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
  # Safe Eyes picks its translation via setlocale, which fails unless the locale is generated.
  i18n.extraLocales = [ "zh_CN.UTF-8/UTF-8" ];

  # A plain unit instead of HM's services.safeeyes, whose ExecStart ignores its package option.
  systemd.user.services.safeeyes = {
    description = "Safe Eyes";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    # Chinese UI only for Safe Eyes; the session stays en_US.
    environment.LC_MESSAGES = "zh_CN.UTF-8";
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

      # Break screen uses the Stylix roles of the Noctalia target, exposed to style.css as @baseXX.
      xdg.configFile."safeeyes/style/safeeyes_custom_style.css".text =
        let
          colors = config.lib.stylix.colors.withHashtag;
          defineColor = name: "@define-color ${name} ${colors.${name}};";
        in
        ''
          ${lib.concatMapStringsSep "\n" defineColor [
            "base00"
            "base01"
            "base02"
            "base03"
            "base04"
            "base05"
            "base0C"
          ]}

          .break_screen_root {
            font-family: "${config.stylix.fonts.sansSerif.name}";
          }

          ${builtins.readFile ./style.css}
        '';
    };
}
