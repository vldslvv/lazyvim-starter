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

        -- Mason runs the adapter; the project interpreter does not need debugpy.
        require("dap-python").setup("debugpy-adapter")

        local dap = require("dap")
        local function validate_python(path)
          if vim.fn.executable(path) == 1 then
            return path
          end
          vim.notify(
            "Cannot launch Python debugger: interpreter is missing or not executable: "
              .. path
              .. "\nSelect another environment with :VenvSelect (<leader>cv), or repair/activate your environment and restart Neovim.",
            vim.log.levels.ERROR
          )
          return dap.ABORT
        end

        local function resolve_python()
          local selector = package.loaded["venv-selector"]
          local selected = selector and selector.python()
          if selected and selected ~= "" then
            return validate_python(selected)
          end

          for _, variable in ipairs({ "VIRTUAL_ENV", "CONDA_PREFIX" }) do
            local env = vim.env[variable]
            if env and env ~= "" then
              return validate_python(env .. "/bin/python")
            end
          end

          for _, root in ipairs({ LazyVim.root(), vim.fn.getcwd() }) do
            for _, folder in ipairs({ ".venv", "venv", "env", ".env" }) do
              local env = root .. "/" .. folder
              if vim.fn.isdirectory(env) == 1 then
                return validate_python(env .. "/bin/python")
              end
            end
          end

          for _, command in ipairs({ "python", "python3" }) do
            local path = vim.fn.exepath(command)
            if path ~= "" then
              return validate_python(path)
            end
          end
          vim.notify(
            "Cannot launch Python debugger: no Python interpreter found. Install Python and create a project environment "
              .. "with `python3 -m venv .venv`, or select an existing environment with :VenvSelect (<leader>cv).",
            vim.log.levels.ERROR
          )
          return dap.ABORT
        end

        dap.listeners.on_config["project_python"] = function(config)
          if
            (config.type == "python" or config.type == "debugpy")
            and config.request == "launch"
            and config.python == nil
            and config.pythonPath == nil
          then
            -- Keep the saved configuration unresolved for subsequent launches/run_last.
            return vim.tbl_extend("force", config, { python = resolve_python() })
          end
          return config
        end

        -- allow stepping into stdlib/site-packages and follow child processes
        dap.configurations.python = {
          {
            type = "python",
            request = "launch",
            name = "Launch current file (with libs)",
            program = "${file}",
            justMyCode = false, -- step into external code
            subProcess = true, -- follow multiprocessing/spawned children
            cwd = "${workspaceFolder}",
          },
        }
      end,
    },
    keys = {
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },

      -- VS Code-like function keybindings
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Debug: Start/Continue",
      },
      {
        "<S-F5>",
        function()
          require("dap").terminate()
        end,
        desc = "Debug: Stop",
      },
      {
        "<C-F5>",
        function()
          require("dap").run_last()
        end,
        desc = "Debug: Run Last",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "Debug: Step Over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "Debug: Step Into",
      },
      {
        "<S-F11>",
        function()
          require("dap").step_out()
        end,
        desc = "Debug: Step Out",
      },
      {
        "<F9>",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Debug: Toggle Breakpoint",
      },
      {
        "<S-F9>",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Debug: Conditional Breakpoint",
      },
      {
        "<F6>",
        function()
          require("dap").pause()
        end,
        desc = "Debug: Pause",
      },

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
