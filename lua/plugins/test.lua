-- Test runner: neotest over `go test` (neotest-golang).
-- Pass/fail shows as a gutter sign next to each test; output opens in a float.
return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "fredrikaverpil/neotest-golang",
    },
    keys = {
      { "<leader>tt", function() require("neotest").run.run() end, desc = "Test: run nearest" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test: run file" },
      { "<leader>tp", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Test: run project" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Test: re-run last" },
      { "<leader>tx", function() require("neotest").run.stop() end, desc = "Test: stop" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Test: toggle summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Test: show output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Test: output panel" },
      { "<leader>td", function() require("neotest").run.run({ suite = false, strategy = "dap" }) end, desc = "Test: debug nearest" },
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-golang")({
            go_test_args = { "-v", "-race", "-count=1" },
            dap_go_enabled = true, -- lets <leader>td debug the test under the cursor
          }),
        },
      })
    end,
  },
}
