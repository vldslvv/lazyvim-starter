-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Escape with jk
vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("t", "jk", "<C-\\><C-n>", { noremap = true, silent = true })

-- Ignore indentation by pressing Alt+Enter
vim.keymap.set("i", "<a-cr>", "<cr><C-u>")

-- Terminal in current window (regular buffer)
vim.keymap.set("n", "<leader>wt", "<cmd>terminal<cr>", { desc = "Terminal" })
vim.keymap.set("n", "<leader>wa", "<cmd>terminal claude<cr>", { desc = "Terminal with claude" })
