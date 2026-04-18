require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { src = "https://github.com/antosha417/nvim-lsp-file-operations" },
    { src = "https://github.com/folke/neodev.nvim" },
  })

  require("neodev").setup({})
  require("lsp-file-operations").setup()

  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  local capabilities = cmp_nvim_lsp.default_capabilities()

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
      local opts = { buffer = ev.buf, silent = true }

      opts.desc = "Show LSP references"
      vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

      opts.desc = "Go to declaration"
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

      opts.desc = "Show LSP definitions"
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

      opts.desc = "Show LSP implementations"
      vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

      opts.desc = "Show LSP type definitions"
      vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

      opts.desc = "See available code actions"
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

      opts.desc = "Smart rename"
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

      opts.desc = "Show buffer diagnostics"
      vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

      opts.desc = "Show line diagnostics"
      vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

      opts.desc = "Go to previous diagnostic"
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

      opts.desc = "Go to next diagnostic"
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

      opts.desc = "Show documentation for what is under cursor"
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

      opts.desc = "Restart LSP"
      vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
    end,
  })

  local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = signs.Error,
        [vim.diagnostic.severity.WARN] = signs.Warn,
        [vim.diagnostic.severity.HINT] = signs.Hint,
        [vim.diagnostic.severity.INFO] = signs.Info,
      },
    },
  })

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
        additionalValuesFilesGlobPattern = "values*.yaml",
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
        },
      },
    },
  }

  for server, config in pairs(servers) do
    vim.lsp.config(server, config)
  end

  -- angularls requires per-project probe locations; vim.lsp.start is used directly
  -- so the cmd is computed dynamically per buffer rather than stored statically
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "typescript", "html", "typescriptreact", "htmlangular" },
    callback = function(ev)
      local root = vim.fs.root(ev.buf, { "angular.json", "project.json", "nx.json" })
      if not root then return end
      -- In NX workspaces node_modules is hoisted to the workspace root,
      -- which may be above the per-app project.json root
      local nm_root = vim.fs.root(ev.buf, "node_modules") or root
      local node_modules = nm_root .. "/node_modules"
      vim.lsp.start({
        name = "angularls",
        cmd = {
          "ngserver",
          "--stdio",
          "--tsProbeLocations", node_modules,
          "--ngProbeLocations", node_modules,
        },
        root_dir = root,
        capabilities = capabilities,
        filetypes = { "typescript", "html", "typescriptreact", "htmlangular" },
      })
    end,
  })

  if os.getenv("DOTNET_ROOT") or vim.fn.executable("dotnet") == 1 then
    vim.lsp.config("roslyn", {
      capabilities = capabilities,
      cmd = { "Microsoft.CodeAnalysis.LanguageServer", "--stdio" },
      root_markers = { "*.sln", "*.csproj" },
    })
    vim.lsp.enable("roslyn")
  end
end)
