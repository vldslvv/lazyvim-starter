return {
  {
    "rmagatti/goto-preview",
    dependencies = { "rmagatti/logger.nvim" },
    opts = {
      focus_on_open = true,
      stack_floating_preview_windows = true,
      vim_ui_input = false,
      -- Preview real source buffers without discarding edits when closing them.
      bufhidden = "hide",
      force_close = false,
    },
    keys = {
      {
        "gpd",
        function()
          require("goto-preview").goto_preview_definition()
        end,
        desc = "Preview Definition",
      },
      {
        "gpt",
        function()
          require("goto-preview").goto_preview_type_definition()
        end,
        desc = "Preview Type Definition",
      },
      {
        "gpi",
        function()
          require("goto-preview").goto_preview_implementation()
        end,
        desc = "Preview Implementation",
      },
      {
        "gP",
        function()
          require("goto-preview").close_all_win()
        end,
        desc = "Close All Previews",
      },
    },
  },
}
