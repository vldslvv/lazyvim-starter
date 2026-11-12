local M = require("helpers")

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.filesystem = opts.filesystem or {}
      -- Refresh when files or directories change outside Neovim.
      opts.filesystem.use_libuv_file_watcher = true
      opts.filesystem.filtered_items = vim.tbl_deep_extend("force", opts.filesystem.filtered_items or {}, {
        hide_dotfiles = false,
        hide_gitignored = true,
      })
      opts.clipboard = vim.tbl_deep_extend("force", opts.clipboard or {}, {
        sync = "universal",
      })
      opts.window = vim.tbl_deep_extend("force", opts.window or {}, {
        width = vim.g.neotree_width or 30,
      })

      -- Inspect only loaded layout windows; tree toggles must not load DAP UI.
      local function dapui_visible(tab)
        if not package.loaded["dapui"] then
          return false
        end
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
          local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
          local floating = vim.api.nvim_win_get_config(win).relative ~= ""
          if not floating and (ft:match("^dapui_") or ft == "dap-repl") then
            return true
          end
        end
        return false
      end

      -- Equalize code panes, or restore DAP dimensions after the tree settles.
      local function equalize_if_side(args)
        if args.position ~= "left" and args.position ~= "right" then
          return
        end
        local tab = vim.api.nvim_get_current_tabpage()
        if not dapui_visible(tab) then
          vim.cmd("wincmd =")
          return
        end
        vim.schedule(function()
          if vim.api.nvim_get_current_tabpage() ~= tab or not dapui_visible(tab) then
            return
          end
          local win = vim.api.nvim_get_current_win()
          package.loaded["dapui"].open({ reset = true })
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_set_current_win(win)
          end
        end)
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
