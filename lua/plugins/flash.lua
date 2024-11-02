M = require("helpers")

return {
  {
    "folke/flash.nvim",
    -- Try to avoid random conflicts with other keymaps by always loading
    lazy = false,
    keys = {
      -- Remove defaults to prevent conflicts
      -- Source:
      -- https://github.com/folke/flash.nvim/discussions/251
      M.disable_keymap("S", "Disable default Flash treesitter key (conflicts with visual surround)", {"v"}),
      -- a-s is Alt+s
      { "<a-s>", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },
}
