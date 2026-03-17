-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<C-;>", function()
	require("snacks.picker").buffers()
end, { desc = "Open buffer picker (Snacks)" })

-- Bind Ctrl+, to alternate buffer (normal mode)
vim.keymap.set("n", "<C-,>", "<Cmd>e #<CR>", { desc = "Switch to previous buffer" })

-- Optional: Make bindings work in insert mode (exit insert mode first)
vim.keymap.set(
	"i",
	"<C-;>",
	"<ESC><CMD>lua require('snacks.picker').buffers()<CR>",
	{ desc = "Open buffer picker (Snacks)" }
)
vim.keymap.set("i", "<C-,>", "<ESC><cmd>b#<CR>", { desc = "Switch to previous buffer" })
