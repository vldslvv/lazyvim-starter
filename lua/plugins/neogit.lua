local function jump_to_section(heading)
  return function()
    vim.fn.search("^" .. heading, "cw")
  end
end

return {
  {
    "NeogitOrg/neogit",
    lazy = true,
    init = function()
      require("config.neogit_session_restore").setup()
    end,
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      {
        "dlyongemallo/diffview-plus.nvim",
        version = "*",
        main = "diffview",
        opts = {},
      },

      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("neogit").setup({
        disable_signs = false,
        integrations = { diffview = true },
        mappings = {
          status = {
            ["<leader>ju"] = jump_to_section("Unstaged changes"),
            ["<leader>js"] = jump_to_section("Staged changes"),
            ["<leader>jt"] = jump_to_section("Untracked files"),
          },
        },
      })
    end,
    cmd = "Neogit",
    keys = {
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
    },
  },
}
