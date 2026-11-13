return {
  { "iamcco/markdown-preview.nvim", enabled = false },
  {
    "brianhuster/live-preview.nvim",
    cmd = "LivePreview",
    opts = { picker = "telescope" },
    config = function(_, opts)
      require("livepreview.config").set(opts)
    end,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("MarkdownPreviewHint", { clear = true }),
        pattern = "markdown",
        callback = function(event)
          require("which-key").add({
            { "<leader>cp", buffer = event.buf, desc = "Markdown Preview", icon = "" },
          })
        end,
      })
    end,
    keys = {
      {
        "<leader>cp",
        function()
          if require("livepreview").is_running() then
            vim.cmd("LivePreview close")
          else
            vim.cmd("LivePreview start")
          end
        end,
        ft = "markdown",
        desc = "Markdown Preview",
      },
    },
  },
}
