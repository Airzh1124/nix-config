-- Record directories visited in Yazi so its `z` key has history to jump to;
-- the plugin does not update the zoxide database unless asked.
require("zoxide"):setup {
	update_db = true,
}

require("full-border"):setup {
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
}