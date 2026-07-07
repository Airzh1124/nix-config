-- Start the Vicinae background service so the launcher toggle key is responsive.
hl.on("hyprland.start", function()
  hl.exec_cmd("vicinae server")
end)
