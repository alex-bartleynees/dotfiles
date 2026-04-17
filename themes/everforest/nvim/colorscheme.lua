vim.pack.add({
  { src = "https://github.com/neanias/everforest-nvim" },
})
require("everforest").setup({})
vim.cmd([[colorscheme everforest]])
