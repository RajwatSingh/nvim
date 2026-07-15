-- LSP: go-to-definition, find references, hover, rename, diagnostics.
-- mason installs the servers; nvim-lspconfig provides the configs;
-- Neovim 0.12's native vim.lsp drives everything.
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        "mason-org/mason.nvim",
        config = function()
          require("mason").setup()
        end,
        init = function()
          -- Formatters (stylua, prettierd, used by conform.nvim) used to
          -- auto-install via a registry refresh + network call on every
          -- startup. Install manually instead: :MasonInstallTools
          vim.api.nvim_create_user_command("MasonInstallTools", function()
            require("mason-registry").refresh(function()
              for _, tool in ipairs({ "stylua", "prettierd", "gofumpt", "goimports" }) do
                local ok, pkg = pcall(require("mason-registry").get_package, tool)
                if ok and not pkg:is_installed() then
                  pkg:install()
                end
              end
            end)
          end, { desc = "Install external formatters via Mason" })
        end,
      },
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- Diagnostics appearance
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = true },
        virtual_text = false, -- no inline end-of-line messages; gutter signs + float only
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
          },
        },
      })

      -- Rounded borders on all floating windows (hover, signature, etc.)
      vim.o.winborder = "rounded"

      -- Completion capabilities (advertised to every server) come from blink.cmp
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- Per-server overrides
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            diagnostics = { globals = { "vim", "Snacks" } },
            completion = { callSnippet = "Replace" },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
            usePlaceholders = true, -- fill in parameter names when completing a call
            completeUnimported = true, -- offer symbols from packages not yet imported
            directoryFilters = { "-.git", "-node_modules", "-vendor" },
            analyses = {
              unusedparams = true,
              unusedwrite = true,
              nilness = true,
              useany = true,
              shadow = true,
            },
          },
        },
      })

      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      -- Keymaps + behavior, set once per buffer when a server attaches
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(event)
          local buf = event.buf
          local function nmap(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
          end

          local ok, builtin = pcall(require, "telescope.builtin")
          -- Use Telescope pickers when available (nicer for multiple results)
          nmap("gd", ok and builtin.lsp_definitions or vim.lsp.buf.definition, "Go to definition")
          nmap("gr", ok and builtin.lsp_references or vim.lsp.buf.references, "References (callers)")
          nmap("gI", ok and builtin.lsp_implementations or vim.lsp.buf.implementation, "Go to implementation")
          nmap("gy", ok and builtin.lsp_type_definitions or vim.lsp.buf.type_definition, "Type definition")
          nmap("gD", vim.lsp.buf.declaration, "Go to declaration")
          nmap("K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "Hover docs")
          nmap("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          nmap("<leader>ca", vim.lsp.buf.code_action, "Code action")
          nmap("<leader>cs", ok and builtin.lsp_document_symbols or vim.lsp.buf.document_symbol, "Document symbols")
        end,
      })

      local servers = {
        "lua_ls",
        "pyright",
        "ruff",
        "gopls",
        "ts_ls",
        "html",
        "cssls",
        "jsonls",
      }

      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_enable = true, -- vim.lsp.enable() installed servers automatically
      })

      -- automatic_enable only covers servers Mason itself installed. gopls is
      -- normally installed with `go install` (into $GOPATH/bin), so Mason never
      -- enables it. Enable any configured server whose binary is on PATH;
      -- vim.lsp.enable() is idempotent, so overlapping with Mason is fine.
      for _, server in ipairs(servers) do
        local cmd = (vim.lsp.config[server] or {}).cmd
        if type(cmd) == "table" and vim.fn.executable(cmd[1]) == 1 then
          vim.lsp.enable(server)
        end
      end
    end,
  },
}
