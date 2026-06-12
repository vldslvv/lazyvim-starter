local M = {}

local function store_path()
  return vim.fn.stdpath("state") .. "/neogit-session-restore.json"
end

local function normalize(path)
  if not path or path == "" then
    return nil
  end

  local ok, normalized = pcall(vim.fs.normalize, vim.fn.fnamemodify(path, ":p"))
  return ok and normalized or vim.fn.fnamemodify(path, ":p")
end

local function session_path()
  local ok, persistence = pcall(require, "persistence")
  if not ok then
    return nil
  end

  local current_ok, current = pcall(persistence.current)
  return current_ok and current or nil
end

local function read_store()
  local file = io.open(store_path(), "r")
  if not file then
    return {}
  end

  local content = file:read("*a")
  file:close()

  if content == "" then
    return {}
  end

  local ok, decoded = pcall(vim.json.decode, content)
  return ok and type(decoded) == "table" and decoded or {}
end

local function write_store(data)
  vim.fn.mkdir(vim.fn.fnamemodify(store_path(), ":h"), "p")

  local file = io.open(store_path(), "w")
  if not file then
    return
  end

  file:write(vim.json.encode(data))
  file:close()
end

local function win_cwd(win)
  local ok, cwd = pcall(vim.api.nvim_win_call, win, vim.fn.getcwd)
  return ok and normalize(cwd) or nil
end

local function visible_neogit_for_cwd(cwd)
  cwd = normalize(cwd)
  if not cwd then
    return false
  end

  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == "NeogitStatus" and win_cwd(win) == cwd then
        return true
      end
    end
  end

  return false
end

local function collect_status_buffers()
  local entries = {}
  local seen = {}

  for tab_index, tab in ipairs(vim.api.nvim_list_tabpages()) do
    for win_index, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == "NeogitStatus" then
        local cwd = win_cwd(win)
        if cwd and not seen[cwd] then
          seen[cwd] = true
          entries[#entries + 1] = {
            tab = tab_index,
            win = win_index,
            cwd = cwd,
          }
        end
      end
    end
  end

  return entries
end

local function focus_saved_window(entry)
  local tabs = vim.api.nvim_list_tabpages()
  local tab = tabs[entry.tab]

  if not tab or not vim.api.nvim_tabpage_is_valid(tab) then
    return false
  end

  vim.api.nvim_set_current_tabpage(tab)

  local wins = vim.api.nvim_tabpage_list_wins(tab)
  local win = wins[entry.win]
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_set_current_win(win)
    return true
  end

  return false
end

local function restore_status_buffers(entries)
  if vim.tbl_isempty(entries) then
    return
  end

  pcall(function()
    require("lazy").load({ plugins = { "neogit" } })
  end)

  local ok, neogit = pcall(require, "neogit")
  if not ok then
    return
  end

  local valid_entries = {}
  for _, entry in ipairs(entries) do
    local valid_entry = type(entry) == "table"
      and type(entry.cwd) == "string"
      and type(entry.tab) == "number"
      and type(entry.win) == "number"

    if valid_entry then
      valid_entries[#valid_entries + 1] = entry
    end
  end

  table.sort(valid_entries, function(a, b)
    if a.tab == b.tab then
      return a.win < b.win
    end
    return a.tab < b.tab
  end)

  for _, entry in ipairs(valid_entries) do
    local can_restore = vim.fn.isdirectory(entry.cwd) == 1
      and not visible_neogit_for_cwd(entry.cwd)

    if can_restore then
      local focused = focus_saved_window(entry)
      neogit.open({
        kind = focused and "replace" or "tab",
        cwd = entry.cwd,
        no_expand = true,
      })
    end
  end
end

function M.setup()
  local group = vim.api.nvim_create_augroup("NeogitSessionRestore", { clear = true })

  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "PersistenceSavePre",
    callback = function()
      local session = session_path()
      if not session then
        return
      end

      local data = read_store()
      local entries = collect_status_buffers()
      data[session] = #entries > 0 and entries or nil
      write_store(data)
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "PersistenceLoadPost",
    callback = function()
      local session = session_path()
      if not session then
        return
      end

      local entries = read_store()[session]
      if type(entries) ~= "table" then
        return
      end

      vim.defer_fn(function()
        restore_status_buffers(entries)
      end, 50)
    end,
  })
end

return M
