-- Cursor theme variables are reused by both environment exports and Hyprland.
local cursor_theme = "Bibata-Modern-Classic"
local cursor_size = "24"

-- Export cursor settings for XWayland, Wayland toolkits, and Hyprland itself.
hl.env("XCURSOR_THEME", cursor_theme)
hl.env("XCURSOR_SIZE", cursor_size)
hl.env("HYPRCURSOR_SIZE", cursor_size)

-- Cursor zoom remains available but unscaled by default.
hl.config({
  cursor = {
    zoom_factor = 1,
    zoom_rigid = false,
    zoom_disable_aa = true,
    hotspot_padding = 1,
  },
})

-- Apply the cursor after Hyprland starts so the live compositor picks it up.
hl.on("hyprland.start", function()
  hl.exec_cmd("hyprctl setcursor " .. cursor_theme .. " " .. cursor_size)
end)
