-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Enable line wrap
vim.opt.wrap = true

-- Keep absolute line numbers on by default; <leader>uL still toggles relative numbers.
vim.opt.relativenumber = false

-- Make title include current directory
vim.opt.title = true
vim.opt.titlestring = "%{"
  .. "len(fnamemodify(getcwd(), ':t')) > 20"
  .. " ? strcharpart(fnamemodify(getcwd(), ':t'), 0, 19) . '…'"
  .. " : fnamemodify(getcwd(), ':t')"
  .. "} - nvim"

-- Disable autoformatting for certain filetypes
vim.g.autoformat = false

vim.g.autohover_disabled = true

vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff"

-- Use one indentation level after an opening parenthesis in Python.
vim.g.python_indent = {
  open_paren = "shiftwidth()",
}

vim.g.lazyvim_picker = "telescope"

vim.g.minipairs_disable = true

-- Neo-tree settings
vim.g.neotree_width = 30

-- Language overrides
vim.g.rust_enabled = true
vim.g.golang_enabled = false
vim.g.haskell_enabled = true

-- Custom setting -- control autocompletion popup from blink
-- TODO: consider binding this to <leader>u. combination
vim.g.blink_enable_auto_completion = true
