-- Go code generation: struct tags, `if err != nil` blocks, interface stubs,
-- test scaffolding. Wraps gomodifytags / iferr / impl / gotests.
-- The helper binaries install with :GoInstallDeps (needs `go` on PATH).
return {
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    build = function()
      vim.cmd.GoInstallDeps()
    end,
    keys = {
      { "<leader>Gj", "<cmd>GoTagAdd json<cr>", ft = "go", desc = "Go: add json struct tags" },
      { "<leader>Gy", "<cmd>GoTagAdd yaml<cr>", ft = "go", desc = "Go: add yaml struct tags" },
      { "<leader>Gr", "<cmd>GoTagRm<cr>", ft = "go", desc = "Go: remove struct tags" },
      { "<leader>Ge", "<cmd>GoIfErr<cr>", ft = "go", desc = "Go: insert if err != nil" },
      { "<leader>Gi", "<cmd>GoImpl<cr>", ft = "go", desc = "Go: implement interface" },
      { "<leader>Gt", "<cmd>GoTestAdd<cr>", ft = "go", desc = "Go: generate test for function" },
      { "<leader>GT", "<cmd>GoTestsAll<cr>", ft = "go", desc = "Go: generate tests for file" },
      { "<leader>Gm", "<cmd>GoMod tidy<cr>", ft = "go", desc = "Go: go mod tidy" },
    },
    opts = {},
  },
}
