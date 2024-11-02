-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Enable line wrap
vim.opt.wrap = true

-- Disable autoformatting for certain filetypes
vim.g.autoformat = false

vim.g.autohover_disabled = true

vim.g.haskell_enabled = true

vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff"
