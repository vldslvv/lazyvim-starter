return {
  {
    "folke/flash.nvim",
    keys = {
      { "<a-s>", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },
}
