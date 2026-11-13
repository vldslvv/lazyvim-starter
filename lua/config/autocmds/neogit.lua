local M = {}

function M.setup()
  vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
    group = vim.api.nvim_create_augroup("NeogitWrap", { clear = true }),
    callback = function(event)
      if vim.bo[event.buf].filetype ~= "NeogitStatus" then
        return
      end

      -- Neogit disables wrapping after FileType, so apply it once setup finishes.
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(event.buf) or vim.bo[event.buf].filetype ~= "NeogitStatus" then
          return
        end
        for _, win in ipairs(vim.fn.win_findbuf(event.buf)) do
          vim.wo[win].wrap = true
          vim.wo[win].linebreak = true
        end
      end)
    end,
  })
end

return M
