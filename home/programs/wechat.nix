{ lib, pkgs, ... }:

let
  textFontFamilies = [
    "sans-serif"
    "sans"
    "system-ui"
    "Arial"
    "Helvetica"
    "Segoe UI"
    "Microsoft YaHei"
    "Microsoft YaHei UI"
    "微软雅黑"
  ];

  mkTextFontAlias = family: ''
    <alias binding="strong">
      <family>${family}</family>
      <prefer>
        <family>Noto Sans CJK SC</family>
        <family>Noto Color Emoji</family>
      </prefer>
    </alias>
  '';

  # Keep WeChat's font substitutions private instead of changing desktop-wide
  # Fontconfig or Stylix defaults.
  wechatFontRules = pkgs.writeText "wechat-font-rules.conf" ''
    <?xml version="1.0"?>
    <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
    <fontconfig>
      <!-- Normalize generic and common proprietary UI font requests. -->
      ${lib.concatMapStrings mkTextFontAlias textFontFamilies}

      <!-- Prefer the color font whenever the application requests Emoji. -->
      <alias binding="strong">
        <family>emoji</family>
        <prefer>
          <family>Noto Color Emoji</family>
        </prefer>
      </alias>
    </fontconfig>
  '';

  wechatFontconfig = pkgs.makeFontsConf {
    # These store references also make both fonts reachable from WeChat's
    # Bubblewrap sandbox.
    fontDirectories = [
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-color-emoji
    ];
    includes = [
      "/etc/fonts/conf.d"
      wechatFontRules
    ];
  };
in
{
  home.packages = [
    # Wrap the final AppImage launcher because overriding its fixup phase does
    # not affect the bubblewrap executable produced by appimageTools.
    (pkgs.symlinkJoin {
      name = "wechat-with-fcitx";
      paths = [ pkgs.wechat ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/wechat \
          --run '${pkgs.xrdb}/bin/xrdb -merge "$HOME/.Xresources"' \
          --set FONTCONFIG_FILE "${wechatFontconfig}" \
          --set GTK_IM_MODULE fcitx \
          --set QT_IM_MODULE fcitx \
          --set XMODIFIERS @im=fcitx \
          --prefix QT_PLUGIN_PATH : "${pkgs.libsForQt5.fcitx5-qt}/${pkgs.libsForQt5.qtbase.qtPluginPrefix}"
      '';
    })
  ];
}
