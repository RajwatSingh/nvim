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
    opts = {
      -- Opening brackets normally add padding spaces: ysiw( -> ( word ).
      -- Override them to behave like the closing ones: ysiw( -> (word).
      surrounds = {
        ["("] = { add = { "(", ")" } },
        ["["] = { add = { "[", "]" } },
        ["{"] = { add = { "{", "}" } },
      },
    },
    config = function(_, opts)
      require("nvim-surround").setup(opts)
      -- Shortcuts for surrounding multiple words / the whole line.
      -- e.g. ys2" -> surround 2 words with "", ysl) -> surround line with ().
      -- Visual-select the words first (viw + e per extra word) so no
      -- trailing space ends up inside the pair, then S surrounds it.
      vim.keymap.set("n", "ys2", "viweS", { remap = true, desc = "Surround 2 words" })
      vim.keymap.set("n", "ys3", "viweeS", { remap = true, desc = "Surround 3 words" })
      vim.keymap.set("n", "ysl", "yss", { remap = true, desc = "Surround line" })
    end,
  },
}
