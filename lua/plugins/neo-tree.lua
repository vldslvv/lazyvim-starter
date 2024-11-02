M = require("helpers")

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },
    },
    keys = {
      M.disable_keymap("<leader>fe", "Disable Explorer NeoTree (Root Dir)"),
      -- M.disable_keymap("<leader>e", "Disable Explorer NeoTree (Root Dir)"),
      { "<leader>e", "", desc = "+explorer", mode = { "n", "v" } },
      {
        "<leader>er",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },

      M.disable_keymap("<leader>fE", "Disable Explorer NeoTree (cwd)"),
      M.disable_keymap("<leader>E", "Disable Explorer NeoTree (cwd)"),
      {
        "<leader>ec",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },

      M.disable_keymap("<leader>ge", "Disable Git Explorer"),
      {
        "<leader>eg",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Explorer For Git",
      },

      M.disable_keymap("<leader>be", "Disable Buffer Explorer"),
      {
        "<leader>eb",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Explorer For Buffer",
      },

      {
        "<leader>ee",
        function()
          require("neo-tree.command").execute({ action = "focus" })
        end,
        desc = "Focus NeoTree",
      },
    },
  },
}
