return {
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {
      enabled = true, -- enable this plugin (the default)
      virt_text_pos = "eol",

      -- custom truncation of variable values
      display_callback = function(variable, buf, stackframe, node, options)
        local max_len = 100
        local value = variable.value:gsub("\n", " ")
        if #value > max_len then
          value = value:sub(1, max_len) .. "…"
        end
        return variable.name .. " = " .. value
      end,
    },
    keys = {
      {
        "<leader>dv",
        function()
          require("nvim-dap-virtual-text").toggle()
        end,
        desc = "Toggle DAP Virtual Text",
      },
    },
  },
}
