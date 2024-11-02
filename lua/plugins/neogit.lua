return {
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed.
      "nvim-telescope/telescope.nvim", -- optional
      -- "ibhagwan/fzf-lua", -- optional
      -- "nvim-mini/mini.pick", -- optional
      -- "folke/snacks.nvim", -- optional
    },
    config = function()
      require("neogit").setup({
        disable_signs = false,
      })
    end,
    cmd = "Neogit",
    keys = {
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
    },
  },
}
