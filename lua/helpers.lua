local M = {}

-- Return a lazy.nvim keys-spec override; an omitted mode defaults to normal mode.
function M.disable_lazy_keymap(keymap, desc, mode)
  return {
    keymap,
    false,
    desc = desc,
    mode = mode,
  }
end

return M
