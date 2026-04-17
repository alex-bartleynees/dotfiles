require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/Decodetalkers/csharpls-extended-lsp.nvim" },
  })
end)
