-- Core editor options. Loaded before plugins.
local opt = vim.opt

-- Leader keys (must be set before plugins / keymaps)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- UI
opt.number = true -- absolute number on the cursor line
opt.relativenumber = true -- relative numbers everywhere else
opt.termguicolors = true -- 24-bit colors
opt.signcolumn = "yes" -- always show sign column so text doesn't jump
opt.numberwidth = 4
-- Gutter is rendered by Neovim's native fast path (sign column + line number).
-- No custom statuscolumn expression and no foldcolumn: both re-evaluate per line
-- per redraw, and folds are open by default (foldlevel=99) so the fold column
-- was mostly empty anyway.
opt.showmode = false -- mode is shown in the statusline instead
opt.shortmess:append("I") -- skip the intro/start screen; open straight to an empty buffer
opt.laststatus = 3 -- single global statusline
opt.pumheight = 10 -- limit completion popup height
opt.pumblend = 10 -- subtle transparency on the popup menu
opt.winblend = 0 -- keep floats crisp on a transparent terminal bg
opt.fillchars:append({ eob = " " }) -- hide the ~ on empty lines
opt.wrap = false

-- Scrolling: keep context around the cursor, scroll smoothly
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.smoothscroll = true

-- Indentation (2 spaces by default; LSP/treesitter adjust per language)
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Splits
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"

-- Files & undo
opt.undofile = true -- persistent undo
opt.swapfile = false
opt.confirm = true -- prompt to save instead of failing on :q

-- Behavior
opt.mouse = "a"
opt.clipboard = "unnamedplus" -- share with system clipboard
opt.updatetime = 200 -- faster CursorHold / diagnostics / git signs
opt.timeoutlen = 400 -- quicker which-key popup
-- NOTE: lazyredraw intentionally NOT set. On modern Neovim with an async
-- statusline/UI it causes visible flicker and stale repaints; the old
-- macro-speedup benefit is negligible now.
opt.completeopt = "menu,menuone,noselect"

-- Folding (treesitter-based, but open by default)
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = "v:lua.require'core.folding'.foldtext()"
opt.fillchars:append({ fold = " ", foldopen = "▾", foldclose = "▸", foldsep = " " }) -- no trailing dots after the fold text; matching foldtext's ▾
opt.foldlevel = 99
opt.foldlevelstart = 99
