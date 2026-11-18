-- Record directories visited in Yazi so its `z` key has history to jump to;
-- the plugin does not update the zoxide database unless asked.
require("zoxide"):setup {
	update_db = true,
}

-- Start in Rime's ASCII mode so keys aren't composed; Rime shares this state per program (rime.conf).
Command("busctl")
	:arg({ "--user", "call", "org.fcitx.Fcitx5", "/rime", "org.fcitx.Fcitx.Rime1", "SetAsciiMode", "b", "true" })
	:spawn()

require("full-border"):setup {
	-- Available values: "plain", "rounded"
	set = "rounded",
}