return {

  {
    "akinsho/bufferline.nvim",
    config = function()
      require("bufferline").setup({
        highlights = {
          buffer_selected = {
            -- Catpuccin theme colors
            fg = "#1e1e2e",
            bg = "#dc8a78",
          },
        },
      })
    end,
  },
}
