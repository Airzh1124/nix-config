{ lib, pkgs, ... }:

# Supply NixOS-specific runtime integration without making VS Code settings read-only.
# https://code.visualstudio.com/docs/configure/settings-sync#_recommended-configure-the-keyring-to-use-with-vs-code
let
  wrappedVscode = pkgs.symlinkJoin {
    name = "vscode-wrapped";
    paths = [ pkgs.vscode ];
    nativeBuildInputs = [ pkgs.makeWrapper ];

    postBuild = ''
      # Continue's bundled sqlite3 binding needs libstdc++ on NixOS.
      wrapProgram $out/bin/code \
        --add-flags "--password-store=gnome-libsecret" \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pkgs.stdenv.cc.cc.lib ]}
    '';

    meta.mainProgram = "code";
  };
in
{
  # Let VS Code and Settings Sync manage ordinary extensions; project devShells
  # provide language runtimes such as Python and Jupyter kernels.
  programs.vscode = {
    enable = true;
    package = wrappedVscode;

    # Keep the Stylix theme extension, but leave settings.json writable so VS Code
    # and Settings Sync can manage theme selection, fonts, and editor preferences.
    profiles.default.userSettings = lib.mkForce { };
  };

  # 不要再写 argvSettings，否则又会生成 ~/.vscode/argv.json 只读
  # argvSettings = {
  #   "password-store" = "gnome-libsecret";
  # };
}
