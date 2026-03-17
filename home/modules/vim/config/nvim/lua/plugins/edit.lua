return {
	{
		"stevearc/conform.nvim",
		opts = {
			-- Define formatters per filetype
			formatters_by_ft = {
				nix = { "nixfmt" },
				lua = { "stylua" },
				python = { "ruff" },
				rust = { "rustfmt" },
			},
			formatters = {
				nixfmt = {
					command = "nixfmt",
					args = {},
					stdin = true,
				},
			},
		},
	},
}
