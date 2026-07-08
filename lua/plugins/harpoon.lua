-- Harpoon: pin a handful of files and teleport between them instantly.
-- Integrates with Telescope so the mark list is searchable and previewable
-- (<leader>fH), while the native quick menu (<leader>H) stays for fast edits.

-- Open the harpoon mark list inside a Telescope picker.
local function harpoon_telescope(harpoon_list)
  local conf = require("telescope.config").values
  local file_paths = {}
  for _, item in ipairs(harpoon_list.items) do
    table.insert(file_paths, item.value)
  end

  require("telescope.pickers")
    .new({}, {
      prompt_title = "Harpoon",
      finder = require("telescope.finders").new_table({ results = file_paths }),
      previewer = conf.file_previewer({}),
      sorter = conf.generic_sorter({}),
    })
    :find()
end

return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- Each callback requires harpoon lazily, so the plugin only loads on first use.
    keys = {
      { "<leader>a", function() require("harpoon"):list():add() end, desc = "Harpoon: add file" },
      {
        "<leader>H",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon: quick menu",
      },
      { "<leader>fH", function() harpoon_telescope(require("harpoon"):list()) end, desc = "Harpoon: marks (Telescope)" },
      { "<C-n>", function() require("harpoon"):list():next() end, desc = "Harpoon: next mark" },
      { "<C-p>", function() require("harpoon"):list():prev() end, desc = "Harpoon: prev mark" },
      { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon: file 1" },
      { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon: file 2" },
      { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon: file 3" },
      { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon: file 4" },
    },
    config = function()
      require("harpoon"):setup()
    end,
  },
}
