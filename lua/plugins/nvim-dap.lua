return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "mfussenegger/nvim-dap-python",
      -- stylua: ignore
      keys = {
        { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
        { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
      },
      config = function()
        if vim.fn.has("win32") == 1 then
          vim.notify("nvim-dap-python not configured on Windows", vim.log.levels.WARN)
          return
        end

        -- point to your project interpreter (must have debugpy installed)
        vim.notify("Using interpreter: " .. vim.g.interpreter_path, vim.log.levels.INFO)
        require("dap-python").setup(vim.g.interpreter_path)
        -- alternatively, Mason can be used, need to figure out how and why
        -- require("dap-python").setup(LazyVim.get_pkg_path("debugpy", "/home/vv/.pyenv/v/3.11.9/envs/nvim-dap-test/bin/python"))

        -- allow stepping into stdlib/site-packages and follow child processes
        local dap = require("dap")
        dap.configurations.python = {
          {
            type = "python",
            request = "launch",
            name = "Launch current file (with libs)",
            program = "${file}",
            justMyCode = false, -- step into external code
            subProcess = true,  -- follow multiprocessing/spawned children
            cwd = "${workspaceFolder}",
          },
        }
      end,
    },
    keys = {
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },

      -- VS Code-like function keybindings
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
      { "<S-F5>", function() require("dap").terminate() end, desc = "Debug: Stop" },
      { "<C-F5>", function() require("dap").run_last() end, desc = "Debug: Run Last" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
      { "<S-F11>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
      { "<S-F9>", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Debug: Conditional Breakpoint" },
      { "<F6>", function() require("dap").pause() end, desc = "Debug: Pause" },

      -- Toggle breakpoint and force an immediate UI refresh so the sign appears right away
      -- NOTE: Not 100% sure this helps
      {
        "<leader>db",
        function()
          local dap = require("dap")
          dap.toggle_breakpoint()
          vim.cmd("redraw") -- refresh UI so the sign shows without moving the cursor
        end,
        desc = "Toggle Breakpoint (instant sign)",
      },
    },
  },
}
