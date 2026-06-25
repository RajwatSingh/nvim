-- Color-coded nested brackets.
return {
  -- Color-code matching brackets/parentheses by nesting depth
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("rainbow-delimiters.setup").setup({})
    end,
  },
}
