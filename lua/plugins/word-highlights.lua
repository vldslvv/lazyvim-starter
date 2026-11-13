return {
  { "folke/snacks.nvim", opts = { words = { enabled = false } } },
  {
    "RRethy/vim-illuminate",
    commit = "1cc33d347c574c3bd21a4852fc9ffed677c1c58c",
    event = "VeryLazy",
    opts = {
      providers = { "lsp", "regex" },
      delay = 200,
      under_cursor = false,
      modes_allowlist = { "n", "i" },
      should_enable = function(buf)
        return vim.bo[buf].buftype == "" and vim.api.nvim_win_get_config(0).relative == ""
      end,
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
      local function highlights()
        for _, kind in ipairs({ "Text", "Read", "Write" }) do
          vim.api.nvim_set_hl(0, "IlluminatedWord" .. kind, { link = "LspReference" .. kind })
        end
      end
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("workspace_illuminate_colors", { clear = true }),
        callback = highlights,
      })
      highlights()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local navigation = { ["]]"] = true, ["[["] = true, ["<a-n>"] = true, ["<a-p>"] = true }
      local defaults = opts.servers["*"]
      if defaults and defaults.keys then
        defaults.keys = vim.tbl_filter(function(key)
          -- Remove LazyVim's retired Snacks words hooks, preserving other keys.
          return not (navigation[key[1]:lower()] and key.has == "documentHighlight" and key.enabled)
        end, defaults.keys)
      end
    end,
  },
}
