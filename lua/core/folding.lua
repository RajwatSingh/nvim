-- Custom fold display.
-- Renders a collapsed block as its first line plus a compact summary, e.g.
--   team_strength = { ⋯ 30 entries } ▾
local M = {}

-- Treesitter foldexpr, but without pulling the vim.treesitter module stack
-- into startup: the initial empty buffer (no filetype) short-circuits to "0",
-- so treesitter only loads once a real file is open. Buffers without a parser
-- (or where we skipped attaching, e.g. large files) also fold to "0".
function M.foldexpr()
  local buf = vim.api.nvim_get_current_buf()
  if vim.b[buf].ts_folds == nil then
    if vim.bo[buf].filetype == "" then
      return "0"
    end
    -- Same 1MB cutoff as the treesitter attach guard: computing folds parses
    -- the whole buffer, which would defeat the large-file skip.
    local name = vim.api.nvim_buf_get_name(buf)
    local stat = name ~= "" and (vim.uv or vim.loop).fs_stat(name) or nil
    if stat and stat.size > 1024 * 1024 then
      vim.b[buf].ts_folds = false
    else
      vim.b[buf].ts_folds = pcall(vim.treesitter.get_parser, buf)
    end
  end
  return vim.b[buf].ts_folds and vim.treesitter.foldexpr() or "0"
end

-- Lines that open one of these get a matching closer + an "entries" count;
-- anything else falls back to a plain "lines" count.
local closers = { ["{"] = "}", ["["] = "]", ["("] = ")" }

function M.foldtext()
  local first = vim.fn.getline(vim.v.foldstart):gsub("%s+$", "")
  local last_char = first:sub(-1)
  local closer = closers[last_char]

  if closer then
    -- inner entries = everything between the opening and closing bracket lines
    local entries = vim.v.foldend - vim.v.foldstart - 1
    local label = entries == 1 and "entry" or "entries"
    return string.format("%s ⋯ %d %s %s ▾", first, entries, label, closer)
  end

  local lines = vim.v.foldend - vim.v.foldstart + 1
  return string.format("%s  ⋯ %d lines ▾", first, lines)
end

return M
