return {
  -- Retain Terraform LSP, formatting, linting, and the documentation picker.
  { "cappyzawa/telescope-terraform.nvim", enabled = false },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      if vim.g.terraform_enabled then
        opts.linters_by_ft.terraform = { "terraform_validate", "tflint" }
      end
    end,
  },
}
