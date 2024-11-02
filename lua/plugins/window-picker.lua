return {
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    config = function()
      -- Goal: let Neo-tree's explicit window picker reuse Codex/opencode panes.
      -- Only terminals marked by our workspace keymaps are included; regular terminals
      -- stay protected so accidental file opens do not replace arbitrary shell sessions.
      local function is_workspace_terminal(win)
        local ok, buf = pcall(vim.api.nvim_win_get_buf, win)
        return ok and vim.bo[buf].buftype == "terminal" and vim.b[buf].workspace_terminal == true
      end

      require("window-picker").setup({
        hint = "floating-big-letter",
        filter_func = function(windows)
          local current = vim.api.nvim_get_current_win()
          local ignored_filetypes = {
            NvimTree = true,
            ["neo-tree"] = true,
            notify = true,
            snacks_notif = true,
          }

          return vim.tbl_filter(function(win)
            if win == current then
              return false
            end

            local ok, buf = pcall(vim.api.nvim_win_get_buf, win)
            if not ok then
              return false
            end

            if ignored_filetypes[vim.bo[buf].filetype] then
              return false
            end

            -- Terminal windows are selectable only when they opted into workspace behavior.
            if vim.bo[buf].buftype == "terminal" then
              return is_workspace_terminal(win)
            end

            return true
          end, windows)
        end,
      })
    end,
  },
}
