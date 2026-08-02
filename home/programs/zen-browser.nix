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
  home.packages = [ browser ];
}
