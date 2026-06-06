return {

  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts = opts or {}

      local prose_filetypes = {
        gitcommit = true,
        markdown = true,
        text = true,
      }

      local comment_node_types = {
        block_comment = true,
        comment = true,
        comment_content = true,
        line_comment = true,
      }

      local function is_prose_context()
        if prose_filetypes[vim.bo.filetype] then
          return true
        end

        local ok, node = pcall(vim.treesitter.get_node)
        while ok and node do
          if comment_node_types[node:type()] then
            return true
          end
          node = node:parent()
        end

        return false
      end

      -- Optional automatic popup control via global toggle:
      -- Set vim.g.blink_enable_auto_completion = true (e.g. in your init.lua) BEFORE blink loads
      -- to allow all default automatic triggers. If false or nil, completion is manual only.
      local enable_auto = (vim.g.blink_enable_auto_completion == true)

      opts.completion = opts.completion or {}
      opts.completion.menu = opts.completion.menu or {}
      if not enable_auto then
        -- Manual-only mode: disable all automatic popup triggers
        opts.completion.trigger = vim.tbl_deep_extend('force', {
          show_on_insert = false,            -- do not open while just inserting
          show_on_trigger_character = false, -- do not open after trigger chars like '.'
          show_on_keyword = false,           -- do not open after typing word fragments
        }, opts.completion.trigger or {})
      else
        opts.completion.menu.auto_show = function()
          return not is_prose_context()
        end
      end

      -- Keymaps: keep hide mapping; ensure manual trigger available always
      opts.keymap = vim.tbl_extend('force', {
        ['<C-c>'] = { 'hide', 'fallback' },
      }, opts.keymap or {})

      return opts
    end,
  },
}
