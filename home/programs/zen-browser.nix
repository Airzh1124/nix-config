{ inputs, lib, pkgs, ... }:

let
  extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };

  prefs = { };

  extensions = [
    (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
    (extension "immersive-translate" "{5efceaa7-f3a2-4e59-a54b-85319448e305}")
    (extension "darkreader" "addon@darkreader.org")
  ];

  browser = pkgs.wrapFirefox
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped
    {
      extraPrefs = lib.concatLines (
        lib.mapAttrsToList
          (name: value: ''lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});'')
          prefs
      );

      extraPolicies = {
        DisableTelemetry = true;
        ExtensionSettings = builtins.listToAttrs extensions;
        SearchEngines = {
          Default = "google";
          #PreventInstalls = true;
          Remove = [
            "Amazon.com"
            "Bing"
            "DuckDuckGo"
            "eBay"
            "Wikipedia (en)"
          ];
        };
      };
    };
in
{
  home.packages = [
    # 绕过 Mozilla 尚未解决的 Wayland 光标位置同步问题 (https://bugzilla.mozilla.org/show_bug.cgi?id=1865779)
    (browser.overrideAttrs (oldAttrs: {
      # Firefox's native Wayland text-input path does not keep the Fcitx5
      # candidate position in sync, so use the GTK3 input module for Zen only.
      makeWrapperArgs = oldAttrs.makeWrapperArgs ++ [
        "--set"
        "GTK_IM_MODULE"
        "fcitx"
        "--prefix"
        "GTK_PATH"
        ":"
        "${pkgs.fcitx5-gtk}/lib/gtk-3.0"
      ];
    }))
  ];
}
