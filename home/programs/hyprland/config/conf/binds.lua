-- Shared options keep keybindings in sync with the configured terminal/launcher.
local options = require("conf/options")
local mod = options.mod
local ipc = "noctalia msg"
local screenshot = ipc .. " screenshot-region"

-- Core app and shell shortcuts.
hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd(options.terminal))
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd(options.launcher))
hl.bind(mod .. " + S", hl.dsp.exec_cmd(ipc .. " panel-toggle control-center"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd(screenshot))
hl.bind(mod .. " + COMMA", hl.dsp.exec_cmd(ipc .. " settings-toggle"))

-- Hardware keys are delegated to Noctalia so OSD state stays centralized.
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. " volume-up"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. " volume-down"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. " volume-mute"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. " brightness-up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. " brightness-down"))

-- Window/session controls.
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + SHIFT + E", hl.dsp.exit())

-- Tiling controls for the active window/layout.
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + J", hl.dsp.layout("togglesplit"))

-- Directional focus mirrors the arrow key layout.
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Number row maps 1-0 to workspaces 1-10, with Shift moving the active window.
for i = 1, 10 do
  local key = i % 10
  hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Mouse wheel cycles through existing workspaces.
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse button bindings move and resize windows without changing keyboard mode.
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
