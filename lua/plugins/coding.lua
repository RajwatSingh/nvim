-- Coding niceties: auto tags, treesitter text objects.
return {
  -- Auto close / rename HTML & JSX tags (needs treesitter parsers installed)
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "html",
      "xml",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "svelte",
      "vue",
    },
    opts = {},
  },

  -- Function/class text objects + motion between them.
  -- Requires the relevant treesitter parser (install gcc, then :TSInstall <lang>).
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      local function map(mode, lhs, fn, desc)
        vim.keymap.set(mode, lhs, fn, { desc = desc })
      end

      -- Select (operator + visual): e.g. `vif`, `daf`, `cic`
      map({ "x", "o" }, "af", function() select.select_textobject("@function.outer", "textobjects") end, "a function")
      map({ "x", "o" }, "if", function() select.select_textobject("@function.inner", "textobjects") end, "inner function")
      map({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end, "a class")
      map({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end, "inner class")
      map({ "x", "o" }, "aa", function() select.select_textobject("@parameter.outer", "textobjects") end, "a parameter")
      map({ "x", "o" }, "ia", function() select.select_textobject("@parameter.inner", "textobjects") end, "inner parameter")

      -- Jump between functions / classes
      map({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end, "Next function")
      map({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end, "Prev function")
      map({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer", "textobjects") end, "Next function end")
      map({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", "textobjects") end, "Next class")
      map({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end, "Prev class")
    end,
  },
}
