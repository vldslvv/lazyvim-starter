-- Loaded by LazyVim alongside its default autocmds.
require("config.autocmds.hover").setup()
require("config.autocmds.neogit").setup()

-- Keep terminal jobs available when a file replaces their window.
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("workspace_terminals", { clear = true }),
  callback = function(event)
    vim.bo[event.buf].buflisted = true
    vim.bo[event.buf].bufhidden = "hide"
  end,
})

-- Use four spaces for C/C++ (including headers) and Python.
local filetypes = vim.api.nvim_create_augroup("workspace_filetypes", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = filetypes,
  pattern = { "cpp", "c", "python" },
  callback = function(event)
    vim.bo[event.buf].shiftwidth = 4
    vim.bo[event.buf].tabstop = 4
    vim.bo[event.buf].expandtab = true
  end,
})

-- Enable formatting on save for Lua despite the global default.
vim.api.nvim_create_autocmd("FileType", {
  group = filetypes,
  pattern = "lua",
  callback = function(event)
    vim.b[event.buf].autoformat = true
  end,
})
