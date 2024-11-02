return {

  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts = opts or {}

      -- Optional automatic popup control via global toggle:
      -- Set vim.g.blink_enable_auto_completion = true (e.g. in your init.lua) BEFORE blink loads
      -- to allow all default automatic triggers. If false or nil, completion is manual only.
      local enable_auto = (vim.g.blink_enable_auto_completion == true)

      opts.completion = opts.completion or {}
      if not enable_auto then
        -- Manual-only mode: disable all automatic popup triggers
        opts.completion.trigger = vim.tbl_deep_extend('force', {
          show_on_insert = false,            -- do not open while just inserting
          show_on_trigger_character = false, -- do not open after trigger chars like '.'
          show_on_keyword = false,           -- do not open after typing word fragments
        }, opts.completion.trigger or {})
      end

      -- Keymaps: keep hide mapping; ensure manual trigger available always
      opts.keymap = vim.tbl_extend('force', {
        ['<C-c>'] = { 'hide', 'fallback' },
      }, opts.keymap or {})

      return opts
    end,
  },
}
