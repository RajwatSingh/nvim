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
map("t", "<S-z>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
map("t", "<C-h>", [[<C-\><C-n><C-w>h]], { desc = "Terminal: go left" })
map("n", "<leader>tn", "<cmd>terminal<cr>", { desc = "Open new terminal" })

-- Close the current split without closing its buffer (works from terminal mode too)
map({ "n", "t" }, "<C-w>q", function()
  vim.cmd("close")
end, { desc = "Close split (keep buffer)" })

-- Diagnostics
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
map("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Prev diagnostic" })

-- Git quick commands. Output is shown as a notification; for interactive
-- flows use lazygit (<leader>gg). Browse pickers live in plugins/telescope.lua.
local function git(args, ok_msg)
  vim.system({ "git", unpack(args) }, { text = true }, function(res)
    vim.schedule(function()
      local out = vim.trim((res.stdout or "") .. (res.stderr or ""))
      if res.code == 0 then
        vim.notify(out ~= "" and out or (ok_msg or "Done"), vim.log.levels.INFO, { title = "git" })
      else
        vim.notify(out ~= "" and out or "git failed", vim.log.levels.ERROR, { title = "git" })
      end
    end)
  end)
end

map("n", "<leader>ga", function()
  git({ "add", "-A" }, "Staged all changes")
end, { desc = "Git stage all" })
map("n", "<leader>gc", function()
  vim.ui.input({ prompt = "Commit message: " }, function(msg)
    if msg and msg ~= "" then
      git({ "commit", "-m", msg })
    end
  end)
end, { desc = "Git commit" })
map("n", "<leader>gp", function()
  git({ "push" }, "Pushed")
end, { desc = "Git push" })
map("n", "<leader>gl", function()
  git({ "pull" }, "Pulled")
end, { desc = "Git pull" })
map("n", "<leader>gf", function()
  git({ "fetch", "--all", "--prune" }, "Fetched")
end, { desc = "Git fetch (all)" })

-- ---------------------------------------------------------------------------
-- Additional keybindings (purely additive — nothing above is changed).
-- ---------------------------------------------------------------------------

-- Save with Ctrl-S from any mode (returns to normal mode after)
map({ "n", "i", "v" }, "<C-s>", "<cmd>write<cr><Esc>", { desc = "Save file" })

-- Buffers: a leader-based delete that doesn't collide with the existing maps
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map("n", "<leader>bD", "<cmd>bdelete!<cr>", { desc = "Delete buffer (force)" })

-- New empty file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New file" })

-- Window splits
map("n", "<leader>sv", "<C-w>v", { desc = "Split vertical" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split horizontal" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })
map("n", "<leader>sx", "<cmd>close<cr>", { desc = "Close split" })

-- Resize windows with Ctrl + arrows
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Grow window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Shrink window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Shrink window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Grow window width" })

-- Quickfix / location list navigation
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix item" })
map("n", "[q", "<cmd>cprevious<cr>", { desc = "Prev quickfix item" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Open quickfix list" })

-- Paste over a selection without clobbering the yank register
map("x", "<leader>p", [["_dP]], { desc = "Paste (keep yank)" })
-- Delete without yanking
map({ "n", "x" }, "<leader>d", [["_d]], { desc = "Delete (no yank)" })

-- Replace the word under the cursor across the file
map("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], { desc = "Replace word under cursor" })

-- Leader-based terminals (additive alternative; your <S-a> map is untouched)
map("n", "<leader>tv", "<cmd>vertical terminal<cr>", { desc = "Vertical terminal" })
map("n", "<leader>th", "<cmd>split | terminal<cr>", { desc = "Horizontal terminal" })

-- Markdown preview: render the current file in a floating window via glow.
map("n", "<leader>mp", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" or vim.bo.filetype ~= "markdown" then
    vim.notify("Not a markdown buffer", vim.log.levels.WARN, { title = "glow" })
    return
  end

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " Markdown Preview ",
    title_pos = "center",
  })

  local function close()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  vim.fn.jobstart({ "glow", "-p", file }, { term = true, on_exit = close })
  vim.cmd("startinsert")

  vim.keymap.set("t", "q", close, { buffer = buf })
  vim.keymap.set("n", "q", close, { buffer = buf })
  vim.keymap.set("t", "<Esc>", close, { buffer = buf })
  vim.keymao.set("x", "<leader>p", "\"_dp")
end, { desc = "Markdown preview (glow)" })
