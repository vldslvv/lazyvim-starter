local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    -- { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Add my custom fork of LazyVim
    -- { "git@github.com:vldslvv/LazyVim.git", import = "lazyvim.plugins", branch = "patch/custom" },
    { "vldslvv/LazyVim", import = "lazyvim.plugins", branch = "patch/custom" },
    -- Use local fork
    -- { dir = "/mnt/shared_linux/home_shared/code/lazyvim", import = "lazyvim.plugins" },
    -- { "/mnt/shared_linux/home_shared/code/lazyvim", import = "lazyvim.plugins" },

    -- Language servers
    { import = "lazyvim.plugins.extras.lang.clangd" },
    { import = "lazyvim.plugins.extras.lang.cmake" },
    { import = "lazyvim.plugins.extras.lang.python" },
    {
      import = "lazyvim.plugins.extras.lang.typescript",
      enabled = function()
        return vim.g.typescript_enabled
      end,
    },
    {
      import = "lazyvim.plugins.extras.lang.terraform",
      enabled = function()
        return vim.g.terraform_enabled
      end,
    },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.yaml" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.toml" },
    { import = "lazyvim.plugins.extras.lang.docker" },
    -- Check language flags after LazyVim has loaded config/options.lua.
    {
      import = "lazyvim.plugins.extras.lang.rust",
      enabled = function()
        return vim.g.rust_enabled
      end,
    },
    {
      import = "lazyvim.plugins.extras.lang.haskell",
      enabled = function()
        return vim.g.haskell_enabled
      end,
    },
    {
      import = "lazyvim.plugins.extras.lang.go",
      enabled = function()
        return vim.g.golang_enabled
      end,
    },

    -- Utils
    { import = "lazyvim.plugins.extras.util.dot" },

    -- Neotest
    { import = "lazyvim.plugins.extras.test.core" },

    -- Debuggers?
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.dap.nlua" },

    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
