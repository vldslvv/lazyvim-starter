local M = require("helpers")

return {
  {
    "folke/flash.nvim",
    keys = {
      -- Free visual S for surround; retain Flash S in normal and operator-pending modes.
      -- Source:
      -- https://github.com/folke/flash.nvim/discussions/251
      M.disable_lazy_keymap("S", "Disable default Flash treesitter key (conflicts with visual surround)", { "x" }),
      -- a-s is Alt+s
      {
        "<a-s>",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
    },
  },
}
