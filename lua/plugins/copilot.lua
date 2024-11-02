return {
  {
    "zbirenbaum/copilot.lua",
    keys = {
      {
        "<leader>at",
        function()
          if require("copilot.client").is_disabled() then
            require("copilot.command").enable()
          else
            require("copilot.command").disable()
          end
        end,
        desc = "Toggle (Copilot)",
      },
    },
    opts = function()
      local hide_during_completion = vim.g.copilot_hide_during_completion
      local copilot_auto_trigger = vim.g.copilot_auto_trigger


      return {
        suggestion = {
          enabled = true,
          auto_trigger = copilot_auto_trigger,
          hide_during_completion = hide_during_completion,
          debounce = 75,
          keymap = {
            accept = "S-<Tab>",
            accept_word = "<M-w>",
            accept_line = "<M-l>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = true,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
      }
    end,
    copilot_model = vim.g.copilot_model,
  },
}
