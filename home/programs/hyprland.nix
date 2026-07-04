{ ... }:

{
  xdg.configFile = {
    "hypr/hyprland.lua".text = ''
      require("conf/monitors")
      require("conf/appearance")
      require("conf/options")
      require("conf/gestures")
      require("conf/rules")
      require("conf/fcitx5")
      require("conf/noctalia")
      require("conf/vicinae")
      require("conf/binds")
    '';

    "hypr/conf/appearance.lua".text = ''
      hl.config({

        -- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
        general = {
          gaps_in = 5,
          gaps_out = 10,
        },

        decoration = {
          rounding = 20,
          rounding_power = 2,

          shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = 0xee1a1a1a,
          },

          blur = {
            enabled = true,
            size = 3,
            passes = 2,
            vibrancy = 0.1696,
          },
        },

        -- Disable wallpaper
        misc = {
          disable_hyprland_logo = true,
          force_default_wallpaper = 0,
          background_color = 0x111111,
        },

      })
    '';

    "hypr/conf/monitors.lua".text = ''
      hl.monitor({
        output = "eDP-1",
        mode = "2560x1600@240",
        position = "0x0",
        scale = 1.60,
      })
    '';

    "hypr/conf/options.lua".text = ''
      return {
        mod = "SUPER",
        terminal = "kitty",
        launcher = "vicinae toggle",
      }
    '';

    "hypr/conf/gestures.lua".text = ''
      hl.gesture({
        fingers = 3,
        direction = "horizontal",
        action = "workspace",
      })
    '';

    "hypr/conf/rules.lua".text = ''
      -- Layer rules target layer surfaces such as bars, notifications,
      -- docks, panels, and OSDs instead of normal application windows.
      -- This makes Noctalia layers blurred, keeps their popups blurred,
      -- ignores mostly-transparent regions for blur, and disables animations.
      hl.layer_rule({
        name = "noctalia",
        match = {
          namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd)$",
        },
        no_anim = true,
        ignore_alpha = 0.5,
        blur = true,
        blur_popups = true,
      })

      hl.layer_rule({
        name = "vicinae-blur",
        match = {
          namespace = "vicinae",
        },
        blur = true,
        ignore_alpha = 0,
      })

      hl.layer_rule({
        name = "vicinae-no-animation",
        match = {
          namespace = "vicinae",
        },
        no_anim = true,
      })
    '';

    "hypr/conf/fcitx5.lua".text = ''
      hl.env("XMODIFIERS", "@im=fcitx")
      hl.env("QT_IM_MODULE", "fcitx")
      hl.env("QT_IM_MODULES", "wayland;fcitx;ibus")
      hl.env("GLFW_IM_MODULE", "ibus")

      hl.on("hyprland.start", function()
        hl.exec_cmd("fcitx5 -d --replace")
      end)
    '';

    "hypr/conf/noctalia.lua".text = ''
      hl.on("hyprland.start", function()
        hl.exec_cmd("noctalia")
      end)
    '';

    "hypr/conf/vicinae.lua".text = ''
      hl.on("hyprland.start", function()
        hl.exec_cmd("vicinae server")
      end)
    '';

    "hypr/conf/binds.lua".text = ''
      local options = require("conf/options")
      local mod = options.mod
      local ipc = "noctalia msg"

      hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd(options.terminal))
      hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd(options.launcher))
      hl.bind(mod .. " + S", hl.dsp.exec_cmd(ipc .. " panel-toggle control-center"))
      hl.bind(mod .. " + COMMA", hl.dsp.exec_cmd(ipc .. " settings-toggle"))

      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. " volume-up"))
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. " volume-down"))
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. " volume-mute"))
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. " brightness-up"))
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. " brightness-down"))

      hl.bind(mod .. " + Q", hl.dsp.window.close())
      hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
      hl.bind(mod .. " + SHIFT + E", hl.dsp.exit())

      hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mod .. " + P", hl.dsp.window.pseudo())
      hl.bind(mod .. " + J", hl.dsp.layout("togglesplit"))

      hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
      hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
      hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
      hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))

      for i = 1, 10 do
        local key = i % 10
        hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
        hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
      end

      hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

      hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
    '';
  };
}
