-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- Editor appearance
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

-- Editing behavior
-- Disable formatting on save by default; filetype overrides may enable it.
vim.g.autoformat = false
vim.g.minipairs_disable = true

-- Use one indentation level after an opening parenthesis in Python.
vim.g.python_indent = {
  open_paren = "shiftwidth()",
}

-- Completion and hover
vim.g.autohover_disabled = true
-- Control the automatic completion popup from blink.
-- TODO: consider binding this to <leader>u. combination
vim.g.blink_enable_auto_completion = true

-- Language support
vim.g.rust_enabled = true
vim.g.golang_enabled = false
vim.g.haskell_enabled = true
vim.g.gitlab_ci_enabled = false

vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff"

-- Navigation and layout
vim.g.lazyvim_picker = "telescope"
vim.g.neotree_width = 30

-- DAP UI dimensions (columns / lines)
vim.g.dapui_sidebar_width = 40
vim.g.dapui_bottom_height = 10
