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

-- Blur Vicinae surfaces so launcher UI matches the rest of the shell.
hl.layer_rule({
  name = "vicinae-blur",
  match = {
    namespace = "vicinae",
  },
  blur = true,
  ignore_alpha = 0,
})

-- Disable Vicinae layer animations because the launcher handles its own motion.
hl.layer_rule({
  name = "vicinae-no-animation",
  match = {
    namespace = "vicinae",
  },
  no_anim = true,
})

-- Keyring/auth prompts should receive focus immediately when VS Code asks to unlock secrets.
hl.window_rule({
  name = "auth-prompts-focus",
  match = {
    title = "^(Authentication Required|Unlock Login Keyring)$",
  },
  float = true,
  center = true,
  stay_focused = true,
  focus_on_activate = true,
})
