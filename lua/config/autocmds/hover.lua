local M = {}

vim.api.nvim_create_augroup("LspHover", { clear = true })

-- When hover is called twice on the same object, the floating window gains focus.
-- To avoid this, we keep track of whether hover has been called before.
M.hover_called = true
local excluded_filetypes = { "sh", "json", "toml" }

-- Function to check if the file type is excluded
local function is_excluded_filetype()
  local filetype = vim.bo.filetype
  for _, ft in ipairs(excluded_filetypes) do
    if filetype == ft then
      return true
    end
  end
  return false
end

-- Function to check if LSP clients are available
local function on_buffer_enter()
  if is_excluded_filetype() then
    return
  end

  local clients = vim.lsp.get_clients()
  vim.b.lsp_available = next(clients) ~= nil

  -- Reset hover state
  M.hover_called = true
end

function M.setup()
  -- Autocommand for LspAttach
  vim.api.nvim_create_autocmd("LspAttach", {
    group = "LspHover",
    pattern = "*",
    callback = on_buffer_enter,
  })

  -- Autocommand for BufEnter
  vim.api.nvim_create_autocmd("BufEnter", {
    group = "LspHover",
    pattern = "*",
    callback = on_buffer_enter,
  })

  -- Use the buffer-local variable in the CursorHold autocmd
  vim.api.nvim_create_autocmd("CursorHold", {
    group = "LspHover",
    pattern = "*",
    callback = function()
      if vim.g.autohover_disabled or is_excluded_filetype() then
        return
      end
      if not vim.b.lsp_available then
        return
      end
      if M.hover_called then
        return
      end

      local params = vim.lsp.util.make_position_params()
      vim.lsp.buf_request(0, "textDocument/hover", params, function(err, result, ctx, config)
        if result and result.contents then
          vim.lsp.buf.hover()
          M.hover_called = true
        end
      end)
    end,
  })

  vim.api.nvim_create_autocmd("CursorMoved", {
    group = "LspHover",
    pattern = "*",
    callback = function()
      if is_excluded_filetype() then
        return
      end
      M.hover_called = false
    end,
  })
end

return M
