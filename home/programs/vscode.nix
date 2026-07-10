{ pkgs, ... }:


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
  programs.vscode = {
    enable = true;
    package = vscodeWithLibsecret;

    profiles.default.extensions = with pkgs.vscode-extensions; [
      pkief.material-icon-theme
      jnoortheen.nix-ide
      myriad-dreamin.tinymist
    ];

                        
  };

  # 不要再写 argvSettings，否则又会生成 ~/.vscode/argv.json 只读
  # argvSettings = {
  #   "password-store" = "gnome-libsecret";
  # };
}
