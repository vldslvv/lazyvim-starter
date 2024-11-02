return {
  recommended = true,
  desc = "Language support for dotfiles",
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "shellcheck" } },
  },
}
-- return {
-- Might be unnecessary
-- recommended = function()
--   return LazyVim.extras.wants({
--     ft = "sh",
--   })
-- end,

-- {
--   "williamboman/mason.nvim",
--   opts = {
--     ensure_installed = {
--       "shellcheck",
--       "shfmt",
--     },
--   },
-- },
--
-- }
