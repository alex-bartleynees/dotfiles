require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/okuuva/auto-save.nvim" },
  })

  require("auto-save").setup({})
end)
