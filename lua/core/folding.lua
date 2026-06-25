-- Custom fold display.
-- Renders a collapsed block as its first line plus a compact summary, e.g.
--   team_strength = { ⋯ 30 entries } ▾
local M = {}

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
