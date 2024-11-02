local M = {}

function M.disable_keymap(keymap, desc)
  return {
    keymap,
    false,
    desc = desc,
  }
end

return M
