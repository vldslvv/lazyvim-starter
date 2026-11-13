return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      opts = opts or {}
      opts.defaults = opts.defaults or {}
      opts.pickers = opts.pickers or {}

      opts.defaults.initial_mode = "normal"

      -- Use Telescope's normal selection actions, targeting the terminal that
      -- launched the picker instead of falling back to another editing window.
      local get_selection_window = opts.defaults.get_selection_window
      opts.defaults.get_selection_window = function(picker, entry)
        local win = picker.original_win_id
        if win and vim.api.nvim_win_is_valid(win) then
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].buftype == "terminal" then
            return win
          end
        end
        return get_selection_window and get_selection_window(picker, entry) or 0
      end

      opts.pickers.find_files = opts.pickers.find_files or {}
      opts.pickers.live_grep = opts.pickers.live_grep or {}
      opts.pickers.find_files.hidden = true
      -- Telescope supports hidden directly; preserve any inherited extra args.
      opts.pickers.live_grep.hidden = true

      return opts
    end,
    keys = {
      {
        "<leader>we",
        function()
          require("terminal_picker").open()
        end,
        desc = "Find Terminals",
      },
      {
        "<leader>fA",
        LazyVim.pick("find_files", { hidden = true, no_ignore = true }),
        desc = "Find Files (Hidden and Ignored)",
      },
      {
        "<leader>sA",
        LazyVim.pick("live_grep", {
          additional_args = { "--hidden", "--no-ignore", "--glob", "!.git" },
        }),
        desc = "Grep (Hidden and Ignored)",
      },
      {
        "<leader>bf",
        "<cmd>Telescope buffers sort_mru=true sort_lastused=true ignore_current_buffer=true<cr>",
        desc = "Find Buffers",
      },
    },
  },
}
