-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Escape with jk
vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("t", "jk", "<C-\\><C-n>", { noremap = true, silent = true })

-- Ignore indentation by pressing Alt+Enter
vim.keymap.set("i", "<a-cr>", "<cr><C-u>")

-- Goal: treat only terminals opened by these keymaps as workspace panes.
-- The marker lets integrations replace assistant terminal windows with files,
-- while ordinary :terminal buffers keep the usual protected terminal behavior.
local function open_workspace_terminal(cmd, label)
  local cwd = vim.fn.getcwd()
  local project = vim.fs.basename(vim.fs.root(cwd, ".git") or cwd)
  if cmd and cmd ~= "" then
    vim.cmd.terminal(cmd)
  else
    vim.cmd.terminal()
  end

  vim.b.workspace_terminal = true
  vim.b.workspace_terminal_name = (label or "Shell") .. " · " .. project

  -- Preserve the running terminal job when its window is reused for a file.
  vim.bo.buflisted = true
  vim.bo.bufhidden = "hide"

  -- Allow Neovim 0.10+ windows to swap away from the terminal buffer.
  pcall(function()
    vim.wo.winfixbuf = false
  end)

  vim.cmd.startinsert()
end

-- Terminal in current window (regular buffer)
vim.keymap.set("n", "<leader>wt", function()
  open_workspace_terminal()
end, { desc = "Terminal" })

local use_cursor = vim.g.ai_terminal == "cursor"
local assistant_cmd = use_cursor and "agent" or "codex --no-alt-screen"
local assistant_label = use_cursor and "Cursor" or "Codex"
vim.keymap.set("n", "<leader>wa", function()
  open_workspace_terminal(assistant_cmd, assistant_label)
end, { desc = "Terminal with " .. assistant_label })

vim.keymap.set("n", "<leader>wc", function()
  open_workspace_terminal("claude", "Claude")
end, { desc = "Terminal with claude" })

vim.keymap.set("n", "<leader>wz", function()
  open_workspace_terminal("opencode", "OpenCode")
end, { desc = "Terminal with opencode" })

vim.keymap.set("n", "<leader>wr", function()
  require("terminal_picker").rename()
end, { desc = "Rename Terminal" })
