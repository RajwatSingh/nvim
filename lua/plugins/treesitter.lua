-- Treesitter (main branch — the supported API on Neovim 0.11+).
-- Accurate highlighting, indentation and code structure.
-- NOTE: parsers compile from C. Install a compiler for your languages:
--   sudo dnf install gcc make
-- Bundled parsers (lua, vim, markdown, ...) highlight even without a compiler.
-- After installing gcc, run :TSInstall python typescript tsx javascript html css json
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSUpdate", "TSInstallInfo", "TSLog" },
    config = function()
      require("nvim-treesitter").setup()

      local wanted = {
        "lua",
        "vim",
        "vimdoc",
        "query",
        "python",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "json",
        "yaml",
        "toml",
        "bash",
        "markdown",
        "markdown_inline",
        "dockerfile",
        "gitcommit",
        "diff",
      }

      -- Only install parsers that are actually missing; when everything is
      -- already installed this is a single directory scan, skipping the PATH
      -- lookups and the per-parser re-check that install() does on every load.
      local installed = {}
      for _, lang in ipairs(require("nvim-treesitter.config").get_installed("parsers")) do
        installed[lang] = true
      end
      local missing = vim.tbl_filter(function(lang)
        return not installed[lang]
      end, wanted)

      if #missing > 0 then
        -- Only try to install if a C compiler is available, so we don't
        -- spam build errors. Otherwise bundled parsers still work below.
        local has_cc = vim.fn.executable("cc") == 1 or vim.fn.executable("gcc") == 1 or vim.fn.executable("clang") == 1
        if has_cc then
          require("nvim-treesitter").install(missing)
        end
      end

      -- Start highlighting + treesitter indentation for any buffer whose parser
      -- is available (installed or bundled). pcall keeps missing parsers silent.
      -- Skip big files: parsing a multi-MB (often minified) file can freeze the
      -- UI for seconds; regex highlight / plain editing stays instant.
      local max_filesize = 1024 * 1024 -- 1MB
      local function ts_attach(buf)
        local name = vim.api.nvim_buf_get_name(buf)
        if name ~= "" then
          local stat = (vim.uv or vim.loop).fs_stat(name)
          if stat and stat.size > max_filesize then
            return
          end
        end
        if pcall(vim.treesitter.start, buf) then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
        callback = function(args)
          ts_attach(args.buf)
        end,
      })

      -- Attach to the buffer that triggered loading
      ts_attach(vim.api.nvim_get_current_buf())
    end,
  },
}
