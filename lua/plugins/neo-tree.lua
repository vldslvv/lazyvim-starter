M = require("helpers")

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.filesystem = opts.filesystem or {}
      opts.filesystem.filtered_items = vim.tbl_deep_extend("force", {
        hide_dotfiles = false,
        hide_gitignored = true,
      }, opts.filesystem.filtered_items or {})
      opts.clipboard = vim.tbl_deep_extend("force", {
        sync = "universal",
      }, opts.clipboard or {})

      -- Proportionally resize all other windows when Neo-tree opens/closes on a side.
      local function equalize_if_side(args)
        if args.position == "left" or args.position == "right" then
          vim.cmd("wincmd =")
        end
      end
      opts.event_handlers = opts.event_handlers or {}
      table.insert(opts.event_handlers, {
        event = "neo_tree_window_after_open",
        handler = equalize_if_side,
      })
      table.insert(opts.event_handlers, {
        event = "neo_tree_window_after_close",
        handler = equalize_if_side,
      })

      return opts
    end,
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
