hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULES", "wayland;fcitx;ibus")
hl.env("GLFW_IM_MODULE", "ibus")

hl.on("hyprland.start", function()
  hl.exec_cmd("fcitx5 -d --replace")
end)
