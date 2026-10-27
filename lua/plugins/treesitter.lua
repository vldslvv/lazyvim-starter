return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      require("nvim-treesitter.install").prefer_git = true
      -- Use Python's built-in indenter to handle incomplete syntax while editing.
      opts.indent = opts.indent or {}
      opts.indent.disable = opts.indent.disable or {}
      table.insert(opts.indent.disable, "python")
      return opts
    end,
  },
}
