-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Copilot section
local copilot_disabled = vim.g.copilot_enabled_on_start == false

if copilot_disabled then
  vim.cmd(":Copilot disable")
end

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.env", "*.key", "*.pem", "*.secret", "*.json" },
  callback = function()
    vim.cmd("Copilot disable")
    vim.notify("Copilot disabled for sensitive file", vim.log.levels.WARN)
  end,
})

