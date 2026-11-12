return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      -- Use GHCup's HLS, which matches the installed GHC. The legacy
      -- haskell-debug-adapter is not used by current haskell-tools.
      opts.ensure_installed = vim.tbl_filter(function(tool)
        return tool ~= "haskell-language-server" and tool ~= "haskell-debug-adapter"
      end, opts.ensure_installed or {})
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- The installed HLS build does not include the HLint plugin.
      opts.linters_by_ft.haskell = { "hlint" }
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      -- Use HLS's bundled formatter without a separate fourmolu executable.
      formatters_by_ft = {
        haskell = { "fourmolu", lsp_format = "prefer" },
      },
    },
  },
}
