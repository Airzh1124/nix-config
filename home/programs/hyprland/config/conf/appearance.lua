hl.config({

  -- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
  general = {
    gaps_in = 4,
    gaps_out = 5,
    border_size = 1,
    col = {
      active_border = "rgba(FFD6E0AA)",
      inactive_border = "rgba(A58A8D45)",
    },
    resize_on_border = true,
    allow_tearing = true,
  },

  decoration = {
    rounding = 10,
    rounding_power = 2,

    shadow = {
      enabled = true,
      range = 50,
      render_power = 10,
      color = 0x27000000,
    },

    blur = {
      enabled = true,
      size = 10,
      passes = 3,
      vibrancy = 0.5,
    },

    dim_inactive = true,
    dim_strength = 0.05,
  },

  -- Disable wallpaper
  misc = {
    disable_hyprland_logo = true,
    force_default_wallpaper = 0,
    background_color = 0x111111,
    focus_on_activate = true,
  },

})

hl.window_rule({
  match = {
    pin = true,
  },
  border_color = {
    colors = { "rgba(FFB2BCAA)", "rgba(FFB2BC77)" },
  },
})
