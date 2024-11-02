-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
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

