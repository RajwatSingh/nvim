-- File explorer sidebar.
return {
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer (toggle)" },
      { "<leader>fe", "<cmd>NvimTreeFindFile<cr>", desc = "Explorer (reveal file)" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      hijack_cursor = true,
      sync_root_with_cwd = true,
      view = { width = 34, signcolumn = "no" },
      renderer = {
        group_empty = true,
        indent_markers = { enable = true },
        icons = { git_placement = "after" },
      },
      filters = { dotfiles = false, custom = { "^.git$", "__pycache__", ".venv" } },
      git = { enable = true },
      actions = { open_file = { quit_on_open = false, window_picker = { enable = false } } },
      diagnostics = { enable = true, show_on_dirs = true },
    },
  },
}
