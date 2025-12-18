return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim",                   opts = {} },
  },
  opts = {
    inlay_hints = { enabled = true },
  },
  config = function()
    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    local keymap = vim.keymap -- for conciseness

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- show lsp definitions

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        opts.desc = "Smart rename"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end,
    })

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Change the Diagnostic symbols in the sign column (gutter)
    -- (not in youtube nvim video)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    -- Configure diagnostic signs using the new API
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = signs.Error,
          [vim.diagnostic.severity.WARN] = signs.Warn,
          [vim.diagnostic.severity.HINT] = signs.Hint,
          [vim.diagnostic.severity.INFO] = signs.Info,
        }
      }
    })

    -- Configure LSP servers directly instead of using mason_lspconfig.setup_handlers
    local servers = {
      ts_ls = { capabilities = capabilities },
      html = { capabilities = capabilities },
      cssls = { capabilities = capabilities },
      tailwindcss = { capabilities = capabilities },
      prismals = { capabilities = capabilities },
      pyright = { capabilities = capabilities },
      astro = {
        capabilities = capabilities,
        cmd = { "astro-ls", "--stdio" },
      },
      svelte = {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.js", "*.ts" },
            callback = function(ctx)
              client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
            end,
          })
        end,
      },
      angularls = {
        capabilities = capabilities,
        root_markers = { "angular.json", "project.json" },
      },
      graphql = {
        capabilities = capabilities,
        filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
      },
      emmet_ls = {
        capabilities = capabilities,
        filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
      },
      lua_ls = {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      },
      dockerls = {
        capabilities = capabilities,
        filetypes = { "dockerfile" },
        root_markers = { "Dockerfile", "docker-compose.yml", "docker-compose.yaml" },
        settings = {
          docker = {
            languageserver = {
              diagnostics = {
                enable = true,
                deprecatedMaintainer = "warning",
                directiveCasing = "warning",
                emptyContinuationLine = "warning",
              },
              formatter = {
                enable = true,
                ignoreMultilineInstructions = false,
              },
            },
          },
        },
      },
      helm_ls = {
        capabilities = capabilities,
        logLevel = "info",
        valuesFiles = {
          mainValuesFile = "values.yaml",
          lintOverlayValuesFile = "values.lint.yaml",
          additionalValuesFilesGlobPattern = "values*.yaml"
        },
        yamlls = {
          enabled = true,
          enabledForFilesGlob = "*.{yaml,yml}",
          diagnosticsLimit = 50,
          showDiagnosticsDirectly = false,
          path = "yaml-language-server",
          config = {
            schemas = {
              kubernetes = "templates/**",
            },
            completion = true,
            hover = true,
          }
        }
      },
    }

    -- Setup all servers using the new vim.lsp.config API
    for server, config in pairs(servers) do
      vim.lsp.config(server, config)
    end

    -- Setup csharp_ls (dotnet and csharp-ls are loaded via direnv)
    local dotnet_root = os.getenv("DOTNET_ROOT")
    if dotnet_root or vim.fn.executable("dotnet") == 1 then
      local dotnet_path = dotnet_root and (dotnet_root .. "/bin/dotnet") or "dotnet"
      local has_csharpls_extended, csharpls_extended = pcall(require, 'csharpls_extended')

    local csharp_config = {
      capabilities = capabilities,
      cmd = { "csharp-ls" },
      init_options = {
        dotnetPath = dotnet_path
      },
    }

    if has_csharpls_extended then
      csharp_config.handlers = {
        ["textDocument/definition"] = csharpls_extended.handler,
        ["textDocument/typeDefinition"] = csharpls_extended.handler,
      }
    end

    vim.lsp.config("csharp_ls", csharp_config)
    end
  end,
}
