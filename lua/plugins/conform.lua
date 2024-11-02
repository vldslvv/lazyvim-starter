return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        -- cmake = { "cmake_format" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
        -- Configure clang-format to use 4 spaces and no tabs for C/C++ files
        clang_format = {
          prepend_args = { "-style", "{BasedOnStyle: LLVM, UseTab: Never, IndentWidth: 4}" },
        },
      },
    },
  },
}
