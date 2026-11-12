return {

  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts = opts or {}

      -- Disable completion itself so hidden suggestions cannot be accepted in prose files.
      local enabled = opts.enabled
      opts.enabled = function()
        if vim.bo.filetype == "text" or vim.bo.filetype == "markdown" then
          return false
        end
        if type(enabled) == "function" then
          return enabled()
        end
        return enabled ~= false
      end

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
        opts.completion.trigger = vim.tbl_deep_extend("force", opts.completion.trigger or {}, {
          show_on_insert = false, -- do not open while just inserting
          show_on_trigger_character = false, -- do not open after trigger chars like '.'
          show_on_keyword = false, -- do not open after typing word fragments
          show_on_backspace = false,
          show_on_backspace_in_keyword = false,
          show_on_backspace_after_accept = false,
          show_on_backspace_after_insert_enter = false,
        })
      else
        opts.completion.menu.auto_show = function()
          return not is_prose_context()
        end
      end

      -- Enter always inserts a newline, even when only ghost text is visible.
      -- Keep the inherited Ctrl-Y mapping for explicitly accepting completion.
      opts.keymap = vim.tbl_extend("force", opts.keymap or {}, {
        ["<CR>"] = {
          function(cmp)
            cmp.cancel()
          end,
          "fallback",
        },
        ["<C-c>"] = { "hide", "fallback" },
      })

      return opts
    end,
  },
}
