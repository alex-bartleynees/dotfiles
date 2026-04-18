require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/williamboman/mason.nvim" },
    { src = "https://github.com/williamboman/mason-lspconfig.nvim" },
    { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
  })

  require("mason").setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  })

  require("mason-lspconfig").setup({
    ensure_installed = {
      "ts_ls",
      "html",
      "cssls",
      "tailwindcss",
      "svelte",
      "lua_ls",
      "graphql",
      "emmet_ls",
      "angularls",
      "astro",
      "helm_ls",
      "dockerls",
      "nil_ls",
    },
    handlers = {
      -- angularls is started manually via FileType autocommand in lspconfig.lua
      -- to allow dynamic per-project probe locations
      angularls = function() end,
    },
  })

  require("mason-tool-installer").setup({
    ensure_installed = {
      "prettier",
      "eslint_d",
      "nixfmt",
      "black",
    },
  })
end)
