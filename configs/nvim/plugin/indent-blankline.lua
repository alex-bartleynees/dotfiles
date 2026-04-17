require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
  })

  require("ibl").setup({
    indent = { char = "┊" },
  })
end)
