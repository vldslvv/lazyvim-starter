M = require("helpers")

return {
  {
    "folke/flash.nvim",
    keys = {
      M.disable_keymap("S", "Disable standard flash key"),
      { "<a-s>", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },
}
