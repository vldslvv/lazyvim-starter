# Neovim configuration

Personal LazyVim configuration using Catppuccin Frappe, Telescope, Neo-tree,
Blink completion, Neogit/Diffview+, Neotest, and nvim-dap.

## Setup and dependencies

Use Neovim 0.12+ for the current lockfile. Install Git, ripgrep (`rg`), a C
compiler, and the build tools required by your projects. Telescope's native
fzf extension also needs `make`. Run `:Lazy`, `:Mason`, and `:checkhealth` after
installing the configuration. Commit `lazy-lock.json` when deliberately updating
plugins so the selected versions can be restored with `:Lazy restore`.

Mason installs configured language servers and tools, including clang-format,
Ruff, HLint, debugpy, and codelldb. Haskell uses GHCup's HLS and GHC from `PATH`
instead of Mason's HLS. Python projects should have a virtual environment;
`<leader>cv` selects one. The debugger runs Mason's debugpy adapter with the
selected project interpreter. The optional terminal shortcuts require `codex`,
`agent` (Cursor CLI), `claude`, or `opencode` on `PATH`, depending on the shortcut.

## Configuration

- `lua/config/lazy.lua`: plugin imports and the `vldslvv/LazyVim` fork on
  `patch/custom`. The installed fork's patch is titled “Override Upstream URLs”.
  Keep this source choice explicit when syncing upstream; the helper script is
  `scripts/sync_fork_and_rebase.sh`.
- `lua/config/options.lua`: preferences, language flags, and layout dimensions.
  Rust and Haskell are enabled; Go, Terraform, TypeScript, and GitLab CI support are disabled.
  Set `vim.g.terraform_enabled = true` or `vim.g.typescript_enabled = true` and
  restart Neovim to enable the corresponding language support.
  Set `vim.g.gitlab_ci_enabled = true` and restart Neovim to enable GitLab CI navigation.
  Set `vim.g.ai_terminal = "codex"` (default) or `"cursor"` to choose the assistant
  opened by `<leader>wa`; restart Neovim after changing it.
- `lua/plugins/`: overrides and integrations for individual plugins.
- Language extras are imported in `lazy.lua`; the empty extras list in
  `lazyvim.json` does not mean language support is disabled.

Formatting on save is disabled globally and enabled for Lua. C/C++ formatting
uses the project's `.clang-format` or `_clang-format`; without either,
clang-format uses its standard LLVM fallback. To apply the preferred four-space
style to a project, add a `.clang-format` containing:

```yaml
BasedOnStyle: LLVM
UseTab: Never
IndentWidth: 4
```

Blink is disabled in Markdown and plain text. Enter inserts a newline; Ctrl-Y
accepts completion. `vim.g.blink_enable_auto_completion` is read when Blink loads;
set it to false before loading for manual completion. `vim-illuminate` highlights
LSP symbol references when a supporting server is attached; otherwise it matches
case-sensitive whole words throughout the buffer, including comments and strings.
It excludes the occurrence under the cursor and skips special buffers and floating
windows. The delay is about 200 ms in normal mode and 300 ms in insert mode.
Its native range handling and refresh lifecycle apply; highlighting is disabled
above 10,000 lines.

Automatic LSP hover is disabled by default. Set `vim.g.autohover_enabled = true`
in `lua/config/options.lua` to enable it. It uses the existing idle delay and
shows documentation without taking focus, only in normal editing buffers with
a hover-capable LSP client. Special buffers and floating windows are skipped;
shell, JSON, and TOML files are supported. Native Neovim hover handles both
automatic previews and manual `K`/`KK`. Noice provides the command-line popup
and message UI, with its LSP hover override disabled. Snacks handles notifications.

Snacks handles text input prompts, and Telescope handles selection dialogs via
`telescope-ui-select.nvim`. Browser Markdown previews use `live-preview.nvim`;
`<leader>cp` toggles the server, while `:LivePreview start`, `:LivePreview close`,
and `:LivePreview pick` provide direct control. In-buffer Markdown rendering is
still provided by `render-markdown.nvim`.

Neogit's diff integration uses the maintained `diffview-plus.nvim` fork with
the existing `:DiffviewOpen` and `:DiffviewFileHistory` commands. The old Terraform
state picker (`:Telescope terraform state_list`) is disabled; use the Terraform
CLI for state operations. When `vim.g.terraform_enabled` is true, the Terraform
extra enables `terraform-ls` for completion, hover, definitions (`gd`), and
references (`gr`), plus the documentation picker. TFLint and `terraform validate`
provide diagnostics through nvim-lint. Formatting stays manual (`<leader>cf`).
The Terraform CLI must be available on `PATH` for validation and formatting;
Mason installs `terraform-ls` and TFLint. Configure provider-specific TFLint
plugins in each project's `.tflint.hcl` and run `tflint --init` in that project.

## Custom keys

`<leader>` is Space. Standard LazyVim bindings remain available unless overridden.

| Key | Action |
| --- | --- |
| `jk` | Leave insert or terminal mode |
| `Alt-Enter` | Insert a newline without inherited indentation |
| `Alt-N` / `Alt-P` | Illuminate next / previous reference, if unbound; wrapping follows `wrapscan` |
| `<leader>wt` | Shell in the current window |
| `<leader>we` | Find existing terminals (including hidden terminals) |
| `<leader>wr` | Rename the current terminal |
| `<leader>wa` / `wc` / `wz` | Selected assistant (Codex or Cursor) / Claude / opencode terminal |
| `<leader>er` / `ec` | Toggle Neo-tree at project root / current directory |
| `<leader>eg` / `eb` / `ee` | Git tree / buffer tree / focus tree |
| `<leader>fA` / `sA` | Find / grep hidden and ignored files |
| `<leader>bf` | Recent buffers |
| `<leader>gn` | Neogit |
| `Alt-s` | Flash Treesitter selection |
| Visual `S` | Surround selection |
| `gpd` / `gpt` / `gpi` / `gP` | Preview definition / type / implementation / close previews |
| `<leader>cv` | Select Python environment |
| `<leader>cp` | Toggle browser Markdown preview |
| `F5` / `Shift-F5` / `Ctrl-F5` | Debug continue / stop / run last |
| `F10` / `F11` / `Shift-F11` | Step over / into / out |
| `F9` / `Shift-F9` / `F6` | Breakpoint / conditional breakpoint / pause |
| `<leader>du` / `dU` / `dv` | Toggle DAP UI / reset layout / toggle variable text |

All terminal buffers, including those opened with `:terminal`, can be replaced
with a file in the same window through Telescope and Neo-tree's normal open or
window picker actions. Their jobs continue in hidden, listed buffers, available
through `<leader>we`. Telescope keeps its native selection actions, including
explicit split commands. Persistence sessions preserve tab order, the selected
tab and pane, Neogit status views (including splits and shared views), and each
tab's Neo-tree visibility, source, root, and position. Pane metadata is stored
inside the session file, so quitting an unused editor keeps the previous session
intact. Existing sessions gain the full pane metadata when saved again.

Run `python3 tests/session_restore.py` to check save/restore behavior across
isolated Neovim processes using your installed plugins. Use `--plugins PATH` if
they are outside the default Neovim data directory.

To switch terminals, leave terminal mode with `jk`, then press Space → w → e.
The Telescope picker searches terminal titles and buffer names,
with a preview of recent output. Enter opens the selected terminal in the current
window; press `i` to type into it. Escape cancels the picker. Hidden terminal jobs
keep running, and no new shell is created when selecting an existing terminal.

New workspace terminals get labels such as `Shell · project-name` or
`Codex · project-name`, using the Git root name of the terminal's starting
directory (or the directory name outside Git). To rename any terminal, press
`jk`, then Space → w → r and enter a label such as `backend server` or `tests`.
Canceling or submitting an empty name keeps the current label. Labels appear in
the picker alongside buffer numbers, remain stable when shell titles change,
and last for the terminal buffer's lifetime.
