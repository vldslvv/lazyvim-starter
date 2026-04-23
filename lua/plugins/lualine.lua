-- Tints the entire lualine statusline by current Vim mode.
-- The stock catppuccin lualine theme only colors the outer mode section, so
-- the mode was easy to miss at a glance. This builds a custom theme that
-- blends the mode accent into the b/c sections too, making mode changes
-- (normal/insert/visual/replace/command) visible across the whole bar.

local function parse(hex)
  return tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
end

local function blend(fg, bg, alpha)
  local fr, fg_, fb = parse(fg)
  local br, bg_, bb = parse(bg)
  local r = math.floor(fr * alpha + br * (1 - alpha) + 0.5)
  local g = math.floor(fg_ * alpha + bg_ * (1 - alpha) + 0.5)
  local b = math.floor(fb * alpha + bb * (1 - alpha) + 0.5)
  return string.format("#%02x%02x%02x", r, g, b)
end

local function build_theme()
  local ok, palettes = pcall(require, "catppuccin.palettes")
  if not ok then
    return nil
  end
  local flavour = vim.g.catppuccin_flavour or "frappe"
  local p = palettes.get_palette(flavour)

  local function section(accent, b_alpha, c_alpha)
    return {
      a = { bg = accent, fg = p.base, gui = "bold" },
      b = { bg = blend(accent, p.surface1, b_alpha or 0.4), fg = p.text },
      c = { bg = blend(accent, p.mantle, c_alpha or 0.15), fg = p.text },
    }
  end

  return {
    normal = section(p.blue),
    insert = section(p.green, 0.75, 0.45),
    visual = section(p.mauve, 0.75, 0.45),
    replace = section(p.red, 0.75, 0.45),
    command = section(p.peach, 0.75, 0.45),
    inactive = {
      a = { bg = p.surface0, fg = p.subtext0 },
      b = { bg = p.mantle, fg = p.subtext0 },
      c = { bg = p.mantle, fg = p.subtext0 },
    },
  }
end

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      local theme = build_theme()
      if theme then
        opts.options = opts.options or {}
        opts.options.theme = theme
      end
    end,
  },
}
