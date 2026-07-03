{ ... }:

{
  xdg.configFile = {
    "hypr/hyprland.lua".text = ''
      require("conf/appearance")
      require("conf/options")
      require("conf/fcitx5")
      require("conf/noctalia")
      require("conf/binds")
    '';

    "hypr/conf/appearance.lua".text = ''
      hl.config({
        misc = {
          disable_hyprland_logo = true,
          force_default_wallpaper = 0,
          background_color = 0x111111,
        },
      })
    '';

    "hypr/conf/options.lua".text = ''
      return {
        mod = "SUPER",
        terminal = "kitty",
        launcher = "fuzzel",
      }
    '';

    "hypr/conf/fcitx5.lua".text = ''
      hl.env("GTK_IM_MODULE", "fcitx")
      hl.env("QT_IM_MODULE", "fcitx")
      hl.env("XMODIFIERS", "@im=fcitx")
      hl.env("SDL_IM_MODULE", "fcitx")
      hl.env("GLFW_IM_MODULE", "ibus")

      hl.on("hyprland.start", function()
        hl.exec_cmd("fcitx5 -d")
      end)
    '';

    "hypr/conf/noctalia.lua".text = ''
      hl.on("hyprland.start", function()
        hl.exec_cmd("noctalia")
      end)
    '';

    "hypr/conf/binds.lua".text = ''
      local options = require("conf/options")
      local mod = options.mod

      hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd(options.terminal))
      hl.bind(mod .. " + D", hl.dsp.exec_cmd(options.launcher))
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

      hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic"))
      hl.bind(mod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

      hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

      hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
    '';
  };
}
