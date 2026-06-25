-- Editing power: surround operations.
return {
  -- Add/change/delete surrounding pairs: ysiw) , cs"' , ds( , (visual) S
  {
    "kylechui/nvim-surround",
    version = "*",
    -- Load when a file is opened so all mappings (normal AND visual `S`) exist
    -- before you press anything. Avoids the lazy visual-key re-feed dropping
    -- the selection on first use.
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}
