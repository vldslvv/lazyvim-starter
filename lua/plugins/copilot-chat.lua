M = require("helpers")

return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    keys = {
      -- Disable keys inherited from base LazyVim config
      M.disable_keymap("<leader>aa", "Toggle (CopilotChat)", { "n", "x" }),
      M.disable_keymap("<leader>ax", "Clear (CopilotChat)", { "n", "x" }),
      M.disable_keymap("<leader>aq", "Quick Chat (CopilotChat)", { "n", "x" }),
      M.disable_keymap("<leader>ap", "Prompt Actions (CopilotChat)", { "n", "x" }),

      -- The key here is to use function call and not <cmd>CopilotChatToggle<CR>, which
      -- gives "No range allowed" error
      {
        "<leader>acc",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "x" },
      },
      {
        "<leader>acx",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "Clear (CopilotChat)",
        mode = { "n", "x" },
      },
      {
        "<leader>acq",
        function()
          vim.ui.input({
            prompt = "Quick Chat: ",
          }, function(input)
            if input ~= "" then
              require("CopilotChat").ask(input)
            end
          end)
        end,
        desc = "Quick Chat (CopilotChat)",
        mode = { "n", "x" },
      },
      {
        "<leader>acp",
        function()
          require("CopilotChat").select_prompt()
        end,
        desc = "Prompt Actions (CopilotChat)",
        mode = { "n", "x" },
      },

      -- TODO: consider rewriting these keymaps to use functions like above
      { "<leader>ace", ":CopilotChatExplain<CR>", mode = "v", desc = "Explain Code" },
      { "<leader>acr", ":CopilotChatReview<CR>",  mode = "v", desc = "Review Code" },
      { "<leader>acf", ":CopilotChatFix<CR>",     mode = "v", desc = "Fix Code Issues" },
      { "<leader>aco", ":CopilotChatOptimize<CR>",mode = "v", desc = "Optimize Code" },
      { "<leader>acd", ":CopilotChatDocs<CR>",    mode = "v", desc = "Generate Docs" },
      { "<leader>act", ":CopilotChatTests<CR>",   mode = "v", desc = "Generate Tests" },
      { "<leader>acg", ":CopilotChatCommit<CR>",  mode = "n", desc = "Generate Commit Message" },
      { "<leader>acs", ":CopilotChatCommit<CR>",  mode = "v", desc = "Generate Commit for Selection" },
      { "<leader>acmm", ":CopilotChatModels<CR>",  mode = "n", desc = "View/select available models" },
      { "<leader>acmp", ":CopilotChatPrompts<CR>", mode = "n", desc = "View/select available prompts" },
      { "<leader>acma", ":CopilotChatAgents<CR>",  mode = "n", desc = "View/select available agents" },
    },
    opts = function()
      return {
        auto_insert_mode = false,
        windows = {},
        model = vim.g.copilot_chat_model,
        agent = "copilot",
        prompts = {
          Rename = {
            prompt = 'Please rename the variable correctly in given selection based on context',
            selection = function(source)
              local select = require('CopilotChat.select')
              return select.visual(source)
            end,
          },
          SplitLine = {
            prompt = 'Split the line or lines to ensure they do not exceed 100 characters',
            selection = function(source)
              local select = require('CopilotChat.select')
              return select.visual(source)
            end,
          },
        },
      }
    end,
  },
}
