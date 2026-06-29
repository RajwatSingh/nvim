# Neovim Config

-> A lightweight Neovim setup.
-> IDE features: LSP, fuzzy finding, treesitter, git, and format-on-save.

- **Leader key:** `Space`
- **Discoverability:** press `<leader>` and pause — **which-key** pops up the menu.
  Or `<leader>fk` to fuzzy-search every keymap.
- Opens to a start screen (**mini.starter**) with recent files and quick actions

---

## Requirements

| Tool              | Why                        |
| ----------------- | -------------------------- |
| Neovim ≥ 0.11     | core                       |
| C compiler + `make` | compile treesitter parsers |
| `git`             | plugins, gitsigns, lazygit |
| `node` / `npm`    | some LSP servers           |
| `ripgrep`         | Telescope live-grep        |
| `lazygit`         | git TUI (`<leader>gg`)     |
| `fd` _(optional)_ | faster file finding        |
| A Nerd Font       | icons (set it in your terminal) |

LSP servers & formatters install themselves via **mason** on first launch
(`lua_ls`, `pyright`, `ruff`, `ts_ls`, `html`, `cssls`, `jsonls`; `stylua`,
`prettierd`).

### Install

**macOS** — [Homebrew](https://brew.sh):

```sh
brew install neovim git node ripgrep lazygit fd
# C compiler/make: install Xcode Command Line Tools
xcode-select --install
```

**Linux**

```sh
# Debian / Ubuntu
sudo apt install neovim git nodejs npm ripgrep fd-find build-essential
# lazygit: see https://github.com/jesseduffield/lazygit#installation

# Fedora
sudo dnf install neovim git nodejs npm ripgrep fd-find lazygit gcc make

# Arch
sudo pacman -S neovim git nodejs npm ripgrep fd lazygit base-devel
```

> On Debian/Ubuntu `fd` is the `fdfind` binary; symlink it with `ln -s $(which fdfind) ~/.local/bin/fd`.

**Windows** — [winget](https://learn.microsoft.com/windows/package-manager/) (or [Scoop](https://scoop.sh)):

```powershell
winget install Neovim.Neovim Git.Git OpenJS.NodeJS BurntSushi.ripgrep.MSVC JesseDuffield.lazygit sharkdp.fd
# C compiler/make: install MSVC Build Tools or use zig/mingw
winget install --id Microsoft.VisualStudio.2022.BuildTools
```

> A [Nerd Font](https://www.nerdfonts.com/) is needed on every platform for icons to render — install one and select it in your terminal (e.g. `JetBrainsMono Nerd Font`).

---

## Layout

```
init.lua                entry point
lua/core/
  options.lua           editor options (leader, UI, indentation, folding, ...)
  keymaps.lua           general keymaps (non-plugin)
  autocmds.lua          yank-highlight, restore cursor, q-to-close, terminal
  folding.lua           custom fold text (collapsed-block summary)
  lazy.lua              plugin-manager bootstrap
lua/plugins/            one file per concern
  lsp.lua  completion.lua  telescope.lua  git.lua  explorer.lua
  treesitter.lua  coding.lua  formatting.lua  editing.lua  ui.lua
  navigation.lua  colorscheme.lua  cursor.lua  animate.lua  dashboard.lua
```

---

## First launch

1. `nvim` — lazy.nvim bootstraps and installs all plugins.
2. Restart. Mason installs LSP servers/formatters in the background (`:Mason` to watch).
3. With `gcc` present, treesitter parsers compile automatically. Add more anytime:
   `:TSInstall python typescript tsx javascript html css json`.

---

## Keybindings

### General / editing

| Key                  | Action                                  |
| -------------------- | --------------------------------------- |
| `<Esc>`              | Clear search highlight                  |
| `<C-d>` / `<C-u>`    | Half-page down / up (re-centered)       |
| `n` / `N`            | Next / prev search result (re-centered) |
| `J`                  | Join line below (cursor stays put)      |
| `J` / `K` _(visual)_ | Move selected lines down / up           |
| `<` / `>` _(visual)_ | Indent left / right, keep selection     |
| `<leader>w` / `<C-s>` | Save file (`<C-s>` works in any mode)  |
| `<leader>q`          | Quit window                             |
| `<leader>fn`         | New empty file                          |
| `<leader>p` _(visual)_ | Paste over selection, keep yank register |
| `<leader>d`          | Delete without yanking                  |
| `<leader>sr`         | Replace the word under the cursor in the file |
| `<leader>L`          | Open plugin manager (Lazy)              |
| `<leader>?`          | Show keymaps for current buffer         |

### Buffers & windows

| Key                          | Action                                  |
| ---------------------------- | --------------------------------------- |
| `<Tab>` / `<S-Tab>`          | Next / previous buffer                  |
| `<S-q>` / `<leader>bd`       | Close (delete) buffer                   |
| `<leader>bD`                 | Close buffer (force, discard changes)   |
| `<C-h/j/k/l>`                | Move to left / down / up / right window |
| `<leader>sv` / `<leader>sh`  | Split window vertical / horizontal      |
| `<leader>se`                 | Equalize split sizes                    |
| `<leader>sx`                 | Close current split                     |
| `<C-Up>` / `<C-Down>`        | Grow / shrink window height             |
| `<C-Left>` / `<C-Right>`     | Shrink / grow window width              |
| `]q` / `[q`                  | Next / previous quickfix item           |
| `<leader>xq`                 | Open the quickfix list                  |

### Terminal

| Key                     | Action                              |
| ----------------------- | ----------------------------------- |
| `<S-a>` / `<leader>tv`  | Open a terminal in a vertical split |
| `<leader>th`            | Open a terminal in a horizontal split |
| `<S-z>` _(in terminal)_ | Leave terminal-insert → normal mode |
| `<C-h>` _(in terminal)_ | Jump to the window on the left      |

> Terminal buffers open with no line numbers/sign column and enter insert mode automatically.

### Find — Telescope

| Key                              | Action                          |
| -------------------------------- | ------------------------------- |
| `<leader><space>` / `<leader>ff` | Find files                      |
| `<leader>fg` / `<leader>/`       | Live grep (search project text) |
| `<leader>fw`                     | Grep the word under the cursor  |
| `<leader>fb`                     | Open buffers                    |
| `<leader>fr`                     | Recent files                    |
| `<leader>fd`                     | Diagnostics (project)           |
| `<leader>fh`                     | Help tags                       |
| `<leader>fk`                     | Keymaps                         |
| `<leader>fc`                     | Colorschemes                    |
| `<C-j>` / `<C-k>` _(in picker)_  | Next / previous result          |
| `<Esc>` _(in picker)_            | Close                           |

### File explorer — nvim-tree

| Key          | Action                              |
| ------------ | ----------------------------------- |
| `<leader>e`  | Toggle the file tree                |
| `<leader>fe` | Reveal the current file in the tree |

_Inside the tree:_ `<CR>` open · `a` create · `d` delete · `r` rename · `x`/`c`/`p` cut/copy/paste · `R` refresh · `H` toggle hidden · `?` help.

### Code intelligence — LSP

| Key          | Action                                         |
| ------------ | ---------------------------------------------- |
| `gd`         | Go to definition                               |
| `gD`         | Go to declaration                              |
| `gr`         | References (callers / usages)                  |
| `gI`         | Go to implementation                           |
| `gy`         | Go to type definition                          |
| `K`          | Hover documentation                            |
| `<leader>cr` | Rename symbol                                  |
| `<leader>ca` | Code action                                    |
| `<leader>cs` | Document symbols                               |
| `<leader>cf` | Format buffer (also works in visual mode)      |
| `<leader>ch` | Toggle inlay hints (servers that support them) |

### Diagnostics

| Key          | Action                                        |
| ------------ | --------------------------------------------- |
| `<leader>cd` | Show diagnostics for the current line (float) |
| `]d` / `[d`  | Next / previous diagnostic                    |
| `<leader>fd` | Browse all diagnostics in Telescope           |

### Completion (insert mode) — blink.cmp

| Key                 | Action                                         |
| ------------------- | ---------------------------------------------- |
| `<C-space>`         | Open completion / show docs                    |
| `<C-n>` / `<C-p>`   | Next / previous item                           |
| `<Tab>` / `<S-Tab>` | Next / prev item, or jump snippet placeholders |
| `<CR>`              | Accept selected item                           |
| `<C-y>`             | Accept                                         |
| `<C-e>`             | Dismiss                                        |

> Ghost text previews the top suggestion; signature help shows in a popup as you type.

### Treesitter text objects & motions

Operator/visual (e.g. `vif`, `daf`, `cic`, `via`):
| Object | Meaning |
|--------|---------|
| `af` / `if` | a function / inner function |
| `ac` / `ic` | a class / inner class |
| `aa` / `ia` | a parameter / inner parameter |

Jumps:
| Key | Action |
|-----|--------|
| `]f` / `[f` | Next / previous function start |
| `]F` | Next function end |
| `]c` / `[c` | Next / previous class |

### Surround — nvim-surround

| Key             | Action                       |
| --------------- | ---------------------------- |
| `ysiw)`         | Surround word with `()`      |
| `cs"'`          | Change surrounding `"` → `'` |
| `ds(`           | Delete surrounding `()`      |
| `S)` _(visual)_ | Surround selection with `()` |

### Git

**Quick commands** (run git directly; result shown as a notification):
| Key | Action |
|-----|--------|
| `<leader>ga` | Stage all changes (`git add -A`) |
| `<leader>gc` | Commit (prompts for a message) |
| `<leader>gp` | Push |
| `<leader>gl` | Pull |
| `<leader>gf` | Fetch all (with prune) |

**Browse** (Telescope pickers):
| Key | Action |
|-----|--------|
| `<leader>gs` | Status — stage/unstage & diff files |
| `<leader>gL` | Log — browse commits |
| `<leader>gB` | Branches — switch / inspect |

**gitsigns** (inline, per-hunk):
| Key | Action |
|-----|--------|
| `]h` / `[h` | Next / previous hunk |
| `<leader>hs` / `<leader>hr` | Stage / reset hunk (works on a visual range too) |
| `<leader>hS` / `<leader>hR` | Stage / reset whole buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hd` | Diff this file |
| `<leader>hb` | Blame current line (full) |
| `<leader>gb` | Toggle inline line-blame |

**lazygit** (full TUI — best for interactive flows like rebase/merge):
| Key | Action |
|-----|--------|
| `<leader>gg` | Open lazygit in a floating window |

---

## Formatting

Format-on-save is **on** (ruff → Python, prettierd/prettier → web, stylua → Lua;
falls back to the LSP formatter otherwise).

- `<leader>cf` — format now (normal or visual).
- `:FormatToggle` — disable/enable format-on-save **globally**.
- `:FormatToggle!` — disable/enable for the **current buffer** only.

HTML/JSX tags auto-close and auto-rename (nvim-ts-autotag).

---

## Folding

Treesitter-based folds, **open by default** (`foldlevel = 99`). A collapsed block
shows its first line plus a compact summary — e.g. `team_strength = { ⋯ 30 entries } ▾`
(custom fold text lives in `lua/core/folding.lua`).

| Key         | Action                          |
| ----------- | ------------------------------- |
| `za`        | Toggle fold under the cursor    |
| `zc` / `zo` | Close / open fold               |
| `zR` / `zM` | Open all / close all folds      |

---

## Useful commands

| Command                           | Purpose                                          |
| --------------------------------- | ------------------------------------------------ |
| `:Lazy`                           | Plugin manager UI (install/update/clean/profile) |
| `:Mason`                          | Manage LSP servers / formatters                  |
| `:checkhealth`                    | Diagnose config / plugin / provider issues       |
| `:TSInstall <lang>` / `:TSUpdate` | Install / update treesitter parsers              |
| `:ConformInfo`                    | Show active formatters for the buffer            |
| `:FormatToggle[!]`                | Toggle format-on-save                            |
| `:LazyGit`                        | Git TUI                                          |

---

## Plugins (28)

**UI/look:** rose-pine · lualine · bufferline · indent-blankline · which-key ·
barbecue + nvim-navic (breadcrumb) · rainbow-delimiters · smear-cursor (animated cursor) · mini.starter (start screen) · nvim-web-devicons
**Editor:** telescope · nvim-tree · treesitter (+textobjects) · nvim-surround ·
nvim-autopairs · nvim-ts-autotag
**LSP/complete/format:** nvim-lspconfig · mason (+mason-lspconfig) · blink.cmp
(+friendly-snippets) · conform
**Git:** gitsigns · lazygit · plenary (shared dep)

---

## Behaviors (autocmds)

- Yanked text flashes briefly.

- Reopening a file returns you to your last cursor position.
- `q` closes help/quickfix/man/lspinfo/checkhealth windows.

---
