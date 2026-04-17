require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/akinsho/bufferline.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  })

  require("bufferline").setup({
    options = {
      mode = "tabs",
      separator_style = "slant",
    },
  })
end)
