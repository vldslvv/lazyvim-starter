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
    insert = section(p.green, 0.35, 0.45),
    visual = section(p.mauve, 0.75, 0.45),
    replace = section(p.red, 0.75, 0.45),
    command = section(p.peach, 0.75, 0.45),
    terminal = section(p.teal, 0.75, 0.45),
    inactive = {
      a = { bg = p.surface0, fg = p.subtext0 },
      b = { bg = p.mantle, fg = p.subtext0 },
      c = { bg = p.mantle, fg = p.subtext0 },
    },
  }
end

local function format_breadcrumbs(text, component)
  local reset = component:get_default_hl()
  local section = reset:match("%%#(.-)#")
  local bg = vim.api.nvim_get_hl(0, { name = section, link = false }).bg

  -- Trouble caches normal-mode backgrounds and emits %* between symbols.
  -- Keep its foregrounds, but use the current section background throughout.
  text = text:gsub("%%#(.-)#", function(source)
    local hl = vim.api.nvim_get_hl(0, { name = source, link = false })
    hl.bg = bg
    local target = "Breadcrumb_" .. section .. "_" .. source
    if not vim.deep_equal(vim.api.nvim_get_hl(0, { name = target, link = false }), hl) then
      vim.api.nvim_set_hl(0, target, hl)
    end
    return "%#" .. target .. "#"
  end)
  return (text:gsub("%%[%d]*%*", function()
    return reset
  end))
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
      if vim.g.trouble_lualine and LazyVim.has("trouble.nvim") then
        -- LazyVim appends the Trouble symbols component last in section c.
        local components = opts.sections.lualine_c
        components[#components].fmt = format_breadcrumbs
      end
    end,
  },
}
