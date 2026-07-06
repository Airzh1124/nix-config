local cursor_theme = "Bibata-Modern-Classic"
local cursor_size = "24"

hl.env("XCURSOR_THEME", cursor_theme)
hl.env("XCURSOR_SIZE", cursor_size)
hl.env("HYPRCURSOR_SIZE", cursor_size)

hl.config({
  cursor = {
    zoom_factor = 1,
    zoom_rigid = false,
    zoom_disable_aa = true,
    hotspot_padding = 1,
  },
})

hl.on("hyprland.start", function()
  hl.exec_cmd("hyprctl setcursor " .. cursor_theme .. " " .. cursor_size)
end)
