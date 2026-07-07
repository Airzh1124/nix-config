-- Tell common toolkits to route input through fcitx5 under Wayland.
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULES", "wayland;fcitx;ibus")
hl.env("GLFW_IM_MODULE", "ibus")

-- Start fcitx5 with replacement so reloading the session does not leave stale daemons.
hl.on("hyprland.start", function()
  hl.exec_cmd("fcitx5 -d --replace")
end)
