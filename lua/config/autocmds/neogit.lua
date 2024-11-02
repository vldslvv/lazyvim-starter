local M = {}

-- Define a function to set Neogit-specific keymaps
function SetNeogitKeymaps()
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>ju", ":SearchUnstagedChanges<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>js", ":SearchStagedChanges<CR>", { noremap = true, silent = true })
end

function M.setup()
  -- Neogit keymaps
  -- Define a command to search for 'unstaged changes'
  -- vim.api.nvim_command('command! SearchUnstagedChanges execute "/unstaged changes"')
  vim.api.nvim_command('command! SearchUnstagedChanges execute ":g/^Unstaged changes" | normal! <Esc>')
  -- vim.api.nvim_command('command! SearchStagedChanges execute "/unstaged changes"')
  vim.api.nvim_command('command! SearchStagedChanges execute ":g/^Staged changes" | normal! <Esc>')

  -- Create an autocmd group to avoid duplicate autocmds
  vim.api.nvim_command("augroup NeogitKeymaps")
  vim.api.nvim_command("autocmd!")
  vim.api.nvim_command("autocmd FileType NeogitStatus lua SetNeogitKeymaps()")
  vim.api.nvim_command("augroup END")
end

return M
