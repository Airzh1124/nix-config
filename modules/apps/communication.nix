{ pkgs, ... }:

{
  hm.home.packages = [
    # Telegram client; registers the tg:// and tonsite:// handlers itself.
    pkgs.ayugram-desktop

    # Wrap the final AppImage launcher because overriding its fixup phase does
    # not affect the bubblewrap executable produced by appimageTools.
    (pkgs.symlinkJoin {
      name = "wechat-with-fcitx";
      paths = [ pkgs.wechat ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      # WeChat (4.1.13+) statically links Qt 5.15 with its own Wayland and
      # fcitx5 plugins, so external Qt plugins cannot be loaded. Its fcitx
      # (D-Bus) plugin makes WeChat draw the candidate window itself on
      # Wayland, and its static Qt cannot load the SVG fcitx5 theme, so the
      # window is white. Use the Wayland text-input protocol instead, so fcitx5
      # draws the themed window as for other apps; its Qt only accepts the
      # full protocol name, not "wayland". Fonts follow the system fontconfig:
      # the sandbox binds the host's /etc/fonts.
      postBuild = ''
        wrapProgram $out/bin/wechat \
          --set QT_IM_MODULE text-input-unstable-v3
      '';
    })
  ];
}
