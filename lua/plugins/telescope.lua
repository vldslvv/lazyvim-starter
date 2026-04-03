return {
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        initial_mode = "normal",
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        live_grep = {
          additional_args = function()
            return { "--hidden" }
          end,
        },
      },
    },
    keys = {
      {
        "<leader>bf",
        "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
        desc = "Find Buffers",
      },
    },
  },
}
