-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--

-- Disable autoformatting for certain filetypes
-- TODO: think if for some files we can enable autoformatting in a similar way
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = { "lua", "py", "sh", "json", "yaml", "yml" },
--   callback = function()
--     vim.b.autoformat = false
--   end,
-- })

if not vim.g.autohover_disabled then
  require("config.autocmds.hover").setup()
end
require("config.autocmds.neogit").setup()

-- Use 4 tabs for certain file types
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "cpp", "c", "h", "hpp", "py" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.expandtab = true
  end,
})

-- enable autoformatting for lua files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "lua" },
  callback = function()
    vim.b.autoformat = true
  end,
})
