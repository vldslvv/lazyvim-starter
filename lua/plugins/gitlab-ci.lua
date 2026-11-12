return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      if not vim.g.gitlab_ci_enabled then
        return
      end
      vim.filetype.add({
        pattern = {
          [".*%.gitlab%-ci%.ya?ml"] = "yaml.gitlab",
          [".*/%.gitlab/ci/.*%.ya?ml"] = "yaml.gitlab",
        },
      })
    end,
    opts = function(_, opts)
      if vim.g.gitlab_ci_enabled then
        opts.servers = opts.servers or {}
        opts.servers.gitlab_ci_ls = {}
      end
    end,
  },
}
