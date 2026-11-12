local M = {}

function M.rename()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].buftype ~= "terminal" then
    vim.notify("Switch to a terminal to rename it", vim.log.levels.INFO)
    return
  end

  vim.ui.input({
    prompt = "Terminal name: ",
    default = vim.b[buf].workspace_terminal_name or vim.b[buf].term_title or "",
  }, function(name)
    if name == nil or not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= "terminal" then
      return
    end
    name = vim.trim(name)
    if name ~= "" then
      vim.b[buf].workspace_terminal_name = name
    end
  end)
end

function M.open()
  local terminals = vim.tbl_filter(function(buf)
    return vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buftype == "terminal"
  end, vim.api.nvim_list_bufs())

  if #terminals == 0 then
    vim.notify("No terminals open", vim.log.levels.INFO)
    return
  end

  local actions = require("telescope.actions")
  local state = require("telescope.actions.state")
  local conf = require("telescope.config").values

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Terminals",
      finder = require("telescope.finders").new_table({
        results = terminals,
        entry_maker = function(buf)
          local name = vim.api.nvim_buf_get_name(buf)
          local title = vim.b[buf].workspace_terminal_name or vim.b[buf].term_title or name
          return {
            value = buf,
            bufnr = buf,
            display = string.format("[%d] %s", buf, title),
            ordinal = string.format("%d %s %s %s", buf, title, vim.b[buf].term_title or "", name),
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      previewer = require("telescope.previewers").new_buffer_previewer({
        title = "Recent output",
        define_preview = function(self, entry)
          if not vim.api.nvim_buf_is_valid(entry.bufnr) then
            return
          end
          local count = vim.api.nvim_buf_line_count(entry.bufnr)
          local lines = vim.api.nvim_buf_get_lines(entry.bufnr, math.max(0, count - 200), -1, false)
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
        end,
      }),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local entry = state.get_selected_entry()
          if not entry then
            return
          end
          if not vim.api.nvim_buf_is_valid(entry.bufnr) then
            vim.notify("That terminal has been closed", vim.log.levels.WARN)
            return
          end

          local win = state.get_current_picker(prompt_bufnr).original_win_id
          actions.close(prompt_bufnr)
          if vim.api.nvim_win_is_valid(win) then
            local ok, err = pcall(vim.api.nvim_win_set_buf, win, entry.bufnr)
            if not ok then
              vim.notify(err, vim.log.levels.WARN)
            end
          end
        end)
        return true
      end,
    })
    :find()
end

return M
