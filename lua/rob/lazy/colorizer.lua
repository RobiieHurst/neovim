return {
	"norcalli/nvim-colorizer.lua",
	config = true,
	lazy = true,
	cmd = {
		"ColorizerToggle",
		"ColorizerAttachToBuffer",
		"ColorizerReloadAllBuffers",
		"ColorizerDetachFromBuffer",
	},
	opts = {
		"css",
		"javascript",
		"html",
		"json",
		"sql",
	},
	ft = { "css", "javascript", "html", "json", "sql" },
}
