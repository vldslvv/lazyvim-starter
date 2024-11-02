return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.defaults = opts.defaults or {}
      opts.pickers = opts.pickers or {}

      opts.defaults = vim.tbl_deep_extend("force", {
        initial_mode = "normal",
      }, opts.defaults)
      opts.defaults.mappings = opts.defaults.mappings or {}
      opts.defaults.mappings.i = opts.defaults.mappings.i or {}
      opts.defaults.mappings.n = opts.defaults.mappings.n or {}

      local existing_attach_mappings = opts.defaults.attach_mappings

      -- Goal: make Telescope searches launched from Codex/opencode panes replace that pane.
      -- This only applies to terminals marked by our workspace keymaps; every other window
      -- keeps Telescope's default target-selection behavior.
      local function is_workspace_terminal_win(win)
        if not win or not vim.api.nvim_win_is_valid(win) then
          return false
        end

        local buf = vim.api.nvim_win_get_buf(win)
        return vim.bo[buf].buftype == "terminal" and vim.b[buf].workspace_terminal == true
      end

      local function selected_path(entry)
        if not entry then
          return nil
        end

        if entry.path or entry.filename then
          return entry.path or entry.filename
        end

        if type(entry.value) == "table" then
          return entry.value.path or entry.value.filename
        end

        if type(entry.value) == "string" then
          return entry.value
        end
      end

      local function edit_entry_in_window(entry, win)
        vim.api.nvim_set_current_win(win)

        -- Reuse the original workspace terminal window for the selected file/buffer.
        -- The terminal job survives because the keymap marks these buffers with bufhidden=hide.
        if entry.bufnr and vim.api.nvim_buf_is_valid(entry.bufnr) then
          vim.api.nvim_win_set_buf(win, entry.bufnr)
        else
          local path = selected_path(entry)
          if not path then
            vim.notify("Telescope entry has no file path", vim.log.levels.WARN)
            return
          end

          vim.cmd.edit(vim.fn.fnameescape(path))
        end

        if entry.lnum then
          local line = math.max(entry.lnum, 1)
          local col = math.max((entry.col or 1) - 1, 0)
          pcall(vim.api.nvim_win_set_cursor, win, { line, col })
        end
      end

      local function select_workspace_aware(prompt_bufnr)
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        local action_set = require("telescope.actions.set")

        local picker = action_state.get_current_picker(prompt_bufnr)
        local original_win = picker.original_win_id

        -- Take the explicit path only for marked workspace terminals; fallback stays stock Telescope.
        if is_workspace_terminal_win(original_win) then
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          return edit_entry_in_window(entry, original_win)
        end

        return action_set.edit(prompt_bufnr, "edit")
      end

      opts.defaults.attach_mappings = function(prompt_bufnr, map)
        if existing_attach_mappings and existing_attach_mappings(prompt_bufnr, map) == false then
          return false
        end

        local actions = require("telescope.actions")
        actions.select_default:replace(select_workspace_aware)

        return true
      end

      opts.defaults.mappings.i["<CR>"] = select_workspace_aware
      opts.defaults.mappings.n["<CR>"] = select_workspace_aware

      opts.pickers = vim.tbl_deep_extend("force", {
        find_files = {
          hidden = true,
        },
        live_grep = {
          additional_args = function()
            return { "--hidden" }
          end,
        },
      }, opts.pickers)

      return opts
    end,
    keys = {
      {
        "<leader>bf",
        "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
        desc = "Find Buffers",
      },
    },
  },
}
