return {
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local devicons = require("nvim-web-devicons")

      -- Catppuccin frappe palette
      local active_fg = "#f4b8e4" -- flamingo / pink — bright, unmissable
      local active_bg = "#414559" -- surface0
      local inactive_fg = "#838ba7" -- subtext0
      local inactive_bg = "#292c3c" -- mantle

      require("incline").setup({
        window = {
          padding = 0,
          margin = { horizontal = 0, vertical = 0 },
        },
        hide = {
          cursorline = false,
          focused_win = false,
          only_win = "count_ignored",
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then
            filename = "[No Name]"
          end
          if vim.bo[props.buf].modified then
            filename = filename .. " ●"
          end

          local icon, icon_color = devicons.get_icon_color(filename, vim.bo[props.buf].filetype, { default = true })
          local fg = props.focused and active_fg or inactive_fg
          local bg = props.focused and active_bg or inactive_bg

          return {
            { " " },
            { icon or "", guifg = icon_color, guibg = bg },
            { " " },
            { filename, guifg = fg, guibg = bg, gui = props.focused and "bold" or nil },
            { " " },
          }
        end,
      })
    end,
  },
}
