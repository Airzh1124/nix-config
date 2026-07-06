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
