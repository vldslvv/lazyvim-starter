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

vim.g.lazyvim_picker = "telescope"

vim.g.minipairs_disable = true

-- Debugger settings
vim.g.interpreter_path = vim.fn.system("which python"):gsub("%s+$", "")
vim.notify("Using interpreter: " .. vim.g.interpreter_path)

-- Language overrides
vim.g.rust_enabled = false
vim.g.golang_enabled = false
vim.g.haskell_enabled = false

-- Custom setting -- control autocompletion popup from blink
-- TODO: consider binding this to <leader>u. combination
vim.g.blink_enable_auto_completion = true

-- Copilot settings
vim.g.copilot_enabled_on_start = false
vim.g.copilot_auto_trigger = false
vim.g.copilot_hide_during_completion = true

-- Proxy
vim.g.copilot_proxy = "http://localhost:11435"
vim.g.copilot_proxy_strict_ssl = false

-- Global LLM model/provider variables
local main_model = "gpt-5.2"
local ollama_model = "qwen2.5:0.5b"
local completion_model = "gpt-5.2-codex"

vim.g.copilot_chat_model = main_model
vim.g.copilot_model = completion_model
