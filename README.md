# Neovim Config

A lightweight Neovim setup — LSP, fuzzy finding, treesitter, git, quick file marks (harpoon), and on-demand formatting, themed with **Rosé Pine Moon** (transparent background, so the terminal shows through).

- **Leader key:** `Space`
- **Discoverability:** press `<leader>` and pause — **which-key** shows the menu. Or `<leader>fk` to fuzzy-search every keymap.

---

## Setup

### Requirements

| Tool                | Why                                |
| ------------------- | ---------------------------------- |
| Neovim ≥ 0.11       | core                               |
| C compiler + `make` | compile treesitter parsers         |
| `git`               | plugins, gitsigns, lazygit         |
| `node` / `npm`      | some LSP servers                   |
| `ripgrep`           | Telescope live-grep                |
| `lazygit`           | git TUI (`<leader>gg`)             |
| `glow`              | markdown preview (`<leader>mp`)    |
| `fd` _(optional)_   | faster file finding                |
| `go` _(optional)_   | Go development (gopls, gofumpt, goimports) |
| A Nerd Font         | icons (select it in your terminal) |

LSP servers install themselves via **mason** on first launch
(`lua_ls`, `pyright`, `ruff`, `gopls`, `ts_ls`, `html`, `cssls`, `jsonls`).
Formatters (`stylua`, `prettierd`, `gofumpt`, `goimports`) are **not**
auto-installed — run `:MasonInstallTools` once (or install them yourself;
go-installed binaries in `$GOBIN`/`$GOPATH/bin` are found automatically).

### Install

**macOS** ([Homebrew](https://brew.sh)):

```sh
brew install neovim git node ripgrep lazygit glow fd
xcode-select --install   # C compiler / make
```

**Linux**

```sh
# Fedora
sudo dnf install neovim git nodejs npm ripgrep fd-find lazygit glow gcc make
# Debian / Ubuntu
sudo apt install neovim git nodejs npm ripgrep fd-find build-essential
# Arch
sudo pacman -S neovim git nodejs npm ripgrep fd lazygit glow base-devel
```

> On Debian/Ubuntu `fd` is `fdfind`; symlink it: `ln -s $(which fdfind) ~/.local/bin/fd`.
> `lazygit`/`glow` may need [their own repos](https://github.com/jesseduffield/lazygit#installation) on older distros.

**Windows** ([winget](https://learn.microsoft.com/windows/package-manager/)):

```powershell
winget install Neovim.Neovim Git.Git OpenJS.NodeJS BurntSushi.ripgrep.MSVC JesseDuffield.lazygit sharkdp.fd charmbracelet.glow
winget install --id Microsoft.VisualStudio.2022.BuildTools   # C compiler / make
```

> A [Nerd Font](https://www.nerdfonts.com/) is required on every platform for icons (e.g. `JetBrainsMono Nerd Font`).

### First launch

1. `nvim` — lazy.nvim bootstraps and installs all plugins.
2. Restart. Mason installs LSP servers in the background (`:Mason` to watch).
3. Run `:MasonInstallTools` to install the formatters (`stylua`, `prettierd`, `gofumpt`, `goimports`).
4. With `gcc` present, treesitter parsers compile automatically. Add more anytime:
   `:TSInstall python go typescript tsx javascript html css json`.

---

## Keybindings

### General / editing

| Key                    | Action                                            |
| ---------------------- | ------------------------------------------------- |
| `<Esc>`                | Clear search highlight                            |
| `<C-d>` / `<C-u>`      | Half-page down / up (re-centered)                 |
| `n` / `N`              | Next / prev search result (re-centered)           |
| `J`                    | Join line below (cursor stays put)                |
| `J` / `K` _(visual)_   | Move selected lines down / up                     |
| `<` / `>` _(visual)_   | Indent left / right, keep selection               |
| `<leader>w` / `<C-s>`  | Save file (`<C-s>` works in any mode)             |
| `<leader>q`            | Quit window                                       |
| `<leader>fn`           | New file (prompts for path, creates folders)      |
| `<leader>fN`           | New folder (prompts for path)                     |
| `<leader>p` _(visual)_ | Paste over selection, keep yank register          |
| `<leader>d`            | Delete without yanking                            |
| `<leader>sr`           | Replace the word under the cursor in file         |
| `<leader>mp`           | Markdown preview (glow float; `q`/`Esc` to close) |
| `<leader>L`            | Open plugin manager (Lazy)                        |
| `<leader>?`            | Show keymaps for current buffer                   |

### Buffers & windows

| Key                         | Action                                  |
| --------------------------- | --------------------------------------- |
| `<Tab>` / `<S-Tab>`         | Next / previous buffer                  |
| `<S-q>` / `<leader>bd`      | Close (delete) buffer                   |
| `<leader>bD`                | Close buffer (force, discard changes)   |
| `<C-h/j/k/l>`               | Move to left / down / up / right window |
| `<leader>sv` / `<leader>sh` | Split window vertical / horizontal      |
| `<leader>se`                | Equalize split sizes                    |
| `<leader>sx` / `<C-w>q`     | Close current split (keeps buffer open) |
| `<C-Up>` / `<C-Down>`       | Grow / shrink window height             |
| `<C-Left>` / `<C-Right>`    | Shrink / grow window width              |
| `]q` / `[q`                 | Next / previous quickfix item           |
| `<leader>xq`                | Open the quickfix list                  |

### Terminal

| Key                     | Action                                |
| ----------------------- | ------------------------------------- |
| `<leader>tv`            | Open a terminal in a vertical split   |
| `<leader>th`            | Open a terminal in a horizontal split |
| `<leader>tn`            | Open a terminal in the current window |
| `<S-z>` _(in terminal)_ | Leave terminal-insert → normal mode   |
| `<C-h>` _(in terminal)_ | Jump to the window on the left        |

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

### Quick file marks — Harpoon

Harpoon lets you pin a handful of files you're actively working in and jump
between them instantly — no fuzzy-searching, no buffer cycling. It layers on top
of Telescope: `<leader>fH` opens your marks in a Telescope picker (with preview
and fuzzy filtering), while `<leader>H` gives you the fast native quick menu.

| Key                       | Action                              |
| ------------------------- | ----------------------------------- |
| `<leader>a`               | Add the current file to the list    |
| `<leader>H`               | Toggle the harpoon quick menu       |
| `<leader>fH`              | Browse marks in Telescope (preview) |
| `<leader>1` … `<leader>4` | Jump to mark 1–4                    |
| `<C-n>` / `<C-p>`         | Cycle to next / previous mark       |

**Quick menu (`<leader>H`):** it's a normal editable buffer — reorder marks by
moving lines, delete a line to drop a mark, `<CR>` to open the one under the
cursor, `q` or `<Esc>` to close. Whatever you leave is your new list.

**Telescope vs. quick menu:** the quick menu is for editing the list and fast
number jumps; `<leader>fH` is for when you have many marks and want to fuzzy-find
or preview before opening. Marks persist per project (cwd), so each repo keeps
its own set.

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

Formatting is **manual** (no format-on-save) via conform.nvim: `stylua` for
Lua, `ruff` for Python, `gofumpt` + `goimports` for Go, `prettierd` for
web/JSON/YAML/Markdown — falling back to the LSP formatter otherwise. Go
buffers use hard tabs (width 4), per gofmt convention.

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
| `<CR>` / `<C-y>`    | Accept selected item                           |
| `<C-e>`             | Dismiss                                        |

### Treesitter text objects & motions

Operator/visual (e.g. `vif`, `daf`, `cic`, `via`):

| Object      | Meaning                       |
| ----------- | ----------------------------- |
| `af` / `if` | a function / inner function   |
| `ac` / `ic` | a class / inner class         |
| `aa` / `ia` | a parameter / inner parameter |

Jumps: `]f` / `[f` function start · `]F` function end · `]c` / `[c` class.

### Surround — nvim-surround

| Key             | Action                       |
| --------------- | ---------------------------- |
| `ysiw(`         | Surround word with `()`      |
| `ys2(`          | Surround 2 words with `()`   |
| `ys3(`          | Surround 3 words with `()`   |
| `ysl(`          | Surround whole line with `()`|
| `cs"'`          | Change surrounding `"` → `'` |
| `ds(`           | Delete surrounding `()`      |
| `S)` _(visual)_ | Surround selection with `()` |

Any pair works in place of `(` — e.g. `ys2"`, `ysl{`. Opening brackets
(`(`, `[`, `{`) are configured to add **no** padding spaces, so `ysiw(`
gives `(word)`, same as `ysiw)`.

### Git

**Quick commands** (run git directly; result shown as a notification):

| Key          | Action                           |
| ------------ | -------------------------------- |
| `<leader>ga` | Stage all changes (`git add -A`) |
| `<leader>gc` | Commit (prompts for a message)   |
| `<leader>gp` | Push                             |
| `<leader>gl` | Pull                             |
| `<leader>gf` | Fetch all (with prune)           |

**Browse** (Telescope pickers): `<leader>gs` status · `<leader>gL` log · `<leader>gB` branches.

**gitsigns** (inline, per-hunk):

| Key                         | Action                                           |
| --------------------------- | ------------------------------------------------ |
| `]h` / `[h`                 | Next / previous hunk                             |
| `<leader>hs` / `<leader>hr` | Stage / reset hunk (works on a visual range too) |
| `<leader>hS` / `<leader>hR` | Stage / reset whole buffer                       |
| `<leader>hp`                | Preview hunk                                     |
| `<leader>hd`                | Diff this file                                   |
| `<leader>hb`                | Blame current line (full)                        |
| `<leader>gb`                | Toggle inline line-blame                         |

**lazygit** (full TUI): `<leader>gg` opens lazygit in a floating window.

### Folding

Treesitter folds, open by default. `za` toggle · `zc` / `zo` close / open · `zR` / `zM` open all / close all.
