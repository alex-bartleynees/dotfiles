require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/akinsho/git-conflict.nvim" },
  })

  require("git-conflict").setup()
end)
