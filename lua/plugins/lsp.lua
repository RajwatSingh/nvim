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
          end, { desc = "Install formatter tools via Mason (stylua, prettierd)" })
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
        virtual_text = { prefix = "●", spacing = 4 },
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
            analyses = { unusedparams = true },
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

          -- Inlay hints toggle (Neovim 0.10+)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method("textDocument/inlayHint") then
            nmap("<leader>ch", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
            end, "Toggle inlay hints")
          end
        end,
      })

      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "pyright",
          "ruff",
          "gopls",
          "ts_ls",
          "html",
          "cssls",
          "jsonls",
        },
        automatic_enable = true, -- vim.lsp.enable() installed servers automatically
      })
    end,
  },
}
