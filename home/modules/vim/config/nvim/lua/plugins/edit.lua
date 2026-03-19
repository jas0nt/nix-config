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
					-- Ensure nixfmt uses stdin (required for conform.nvim integration)
					stdin = true,
				},
				stylua = {
					stdin = true,
				},
				ruff = {
					stdin = true,
					args = { "format", "--stdin-filename", "$FILENAME", "-" },
				},
				rustfmt = {
					stdin = true,
				},
			},
		},
	},

	{
		"terryma/vim-expand-region",
	},
}
