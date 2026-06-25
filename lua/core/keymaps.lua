-- General keymaps. Plugin-specific maps live in each plugin spec.
-- LSP maps are set on attach in lua/plugins/lsp.lua.
local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

-- Centered scrolling / search
map({ "n", "v" }, "<C-d>", "<C-d>zz", { desc = "Scroll down (centered)" })
map({ "n", "v" }, "<C-u>", "<C-u>zz", { desc = "Scroll up (centered)" })
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })

-- Buffers
map("n", "<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-q>", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Move selected lines and keep selection / cursor sane
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
map("n", "J", "mzJ`z", { desc = "Join line (keep cursor)" })

-- Stay in visual mode when indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Save / quit
map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit window" })

-- Terminal
map("n", "<S-a>", "<cmd>vertical terminal<cr>", { desc = "Open vertical terminal" })
map("t", "<S-z>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
map("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Terminal: go left" })

-- Diagnostics
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev diagnostic" })
