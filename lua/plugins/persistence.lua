return {
  {
    "folke/persistence.nvim",
    init = function()
      require("config.session_restore").setup()
    end,
  },
}
