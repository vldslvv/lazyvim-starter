local M = {}

function M.setup()
  local group = vim.api.nvim_create_augroup("LspHover", { clear = true })
  local last_context

  vim.api.nvim_create_autocmd({ "CursorMoved", "BufEnter", "WinEnter", "InsertEnter", "TextChanged" }, {
    group = group,
    desc = "Rearm automatic hover when the editing context changes",
    callback = function()
      last_context = nil
    end,
  })

  vim.api.nvim_create_autocmd("CursorHold", {
    group = group,
    desc = "Show optional LSP hover without taking focus",
    callback = function(event)
      if vim.g.autohover_disabled then
        last_context = nil
        return
      end
      local win = vim.api.nvim_get_current_win()
      if
        vim.api.nvim_get_current_buf() ~= event.buf
        or vim.bo[event.buf].buftype ~= ""
        or vim.api.nvim_win_get_config(win).relative ~= ""
        or vim.api.nvim_get_mode().mode ~= "n"
      then
        return
      end
      if #vim.lsp.get_clients({ bufnr = event.buf, method = "textDocument/hover" }) == 0 then
        return
      end

      local cursor = vim.api.nvim_win_get_cursor(win)
      local context = { event.buf, win, cursor[1], cursor[2], vim.api.nvim_buf_get_changedtick(event.buf) }
      if vim.deep_equal(last_context, context) then
        return
      end
      last_context = context
      -- Native hover handles client encodings and discards stale responses.
      vim.lsp.buf.hover({ focus = false, silent = true })
    end,
  })
end

return M
