{ lib, pkgs, ... }:

# 尝试解决 vscode 1需要手动配置 gnome-libsecret 的问题
# https://code.visualstudio.com/docs/configure/settings-sync#_recommended-configure-the-keyring-to-use-with-vs-code
let
  vscodeWithLibsecret = pkgs.symlinkJoin {
    name = "vscode-with-libsecret";
    paths = [ pkgs.vscode ];
    nativeBuildInputs = [ pkgs.makeWrapper ];

    postBuild = ''
      wrapProgram $out/bin/code \
        --add-flags "--password-store=gnome-libsecret"
    '';

    meta.mainProgram = "code";
  };
in
{
  # Let VS Code and Settings Sync manage ordinary extensions; project devShells
  # provide language runtimes such as Python and Jupyter kernels.
  programs.vscode = {
    enable = true;
    package = vscodeWithLibsecret;

    # Keep the Stylix theme extension, but leave settings.json writable so VS Code
    # and Settings Sync can manage theme selection, fonts, and editor preferences.
    profiles.default.userSettings = lib.mkForce { };
  };

  # 不要再写 argvSettings，否则又会生成 ~/.vscode/argv.json 只读
  # argvSettings = {
  #   "password-store" = "gnome-libsecret";
  # };
}
