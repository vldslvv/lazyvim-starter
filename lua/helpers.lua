local M = {}

function M.disable_keymap(keymap, desc, mode)
  local keymap_config = {
    keymap,
    false,
    desc = desc,
  }

  -- Add mode parameter if provided
  if mode then
    keymap_config.mode = mode
  end

  return keymap_config
end

return M
