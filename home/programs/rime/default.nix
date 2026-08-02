{ ... }:

{
  xdg.configFile."fcitx5/conf/rime.conf".text = ''
    # Keep the embedded preedit cursor aligned with the text being composed.
    PreeditCursorPositionAtBeginning=False
  '';

  xdg.dataFile."fcitx5/rime/default.custom.yaml" = {
    force = true;
    source = ./default.custom.yaml;
  };
}
