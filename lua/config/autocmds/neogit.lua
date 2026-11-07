local M = {}

-- Define a function to set Neogit-specific keymaps
function SetNeogitKeymaps()
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>ju", ":SearchUnstagedChanges<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>js", ":SearchStagedChanges<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(0, "n", "<leader>jt", ":SearchUntrackedFiles<CR>", { noremap = true, silent = true })
end

function M.setup()
  vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
    group = vim.api.nvim_create_augroup("NeogitWrap", { clear = true }),
    callback = function(event)
      if vim.bo[event.buf].filetype ~= "NeogitStatus" then
        return
      end

      -- Neogit disables wrapping after FileType, so apply it once setup finishes.
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(event.buf) then
          return
        end
        for _, win in ipairs(vim.fn.win_findbuf(event.buf)) do
          vim.wo[win].wrap = true
          vim.wo[win].linebreak = true
        end
      end)
    end,
  })

  -- Neogit keymaps
  -- Define a command to search for 'unstaged changes'
  vim.api.nvim_command('command! SearchUnstagedChanges execute ":g/^Unstaged changes" | normal! <Esc>')
  vim.api.nvim_command('command! SearchStagedChanges execute ":g/^Staged changes" | normal! <Esc>')
  vim.api.nvim_command('command! SearchUntrackedFiles execute ":g/^Untracked files" | normal! <Esc>')

  -- Create an autocmd group to avoid duplicate autocmds
  vim.api.nvim_command("augroup NeogitKeymaps")
  vim.api.nvim_command("autocmd!")
  vim.api.nvim_command("autocmd FileType NeogitStatus lua SetNeogitKeymaps()")
  vim.api.nvim_command("augroup END")
end

return M
