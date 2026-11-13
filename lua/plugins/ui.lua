return {
  {
    "folke/noice.nvim",
    -- Keep the command-line popup while native hover handles documentation.
    opts = { lsp = { hover = { enabled = false } } },
  },
  { "stevearc/dressing.nvim", enabled = false },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-telescope/telescope-ui-select.nvim" },
    init = function()
      -- Keep selection dialogs available before the first Telescope command.
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "telescope.nvim" } })
        return vim.ui.select(...)
      end
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("ui-select")
    end,
  },
  -- LazyVim already enables Snacks input for rename and other text prompts.
}
