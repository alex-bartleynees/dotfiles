require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/stevearc/conform.nvim" },
  })

  local formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    svelte = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    graphql = { "prettier" },
    liquid = { "prettier" },
    lua = { "stylua" },
    python = { "isort", "black" },
  }


  require("conform").setup({
    formatters_by_ft = formatters_by_ft,
    format_on_save = {
      lsp_fallback = true,
      async = false,
      timeout_ms = 1000,
    },
  })

  vim.keymap.set({ "n", "v" }, "<leader>mp", function()
    require("conform").format({
      lsp_fallback = true,
      async = false,
      timeout_ms = 1000,
    })
  end, { desc = "Format file or range (in visual mode)" })
end)
