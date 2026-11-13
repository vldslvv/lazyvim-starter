return {
  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    event = "VeryLazy",
    version = "2.*",
    opts = {
      hint = "floating-big-letter",
      -- Include terminals while keeping the default utility-window filters.
      filter_rules = { bo = { buftype = {} } },
    },
  },
}
