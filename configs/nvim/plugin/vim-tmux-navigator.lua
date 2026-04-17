require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/christoomey/vim-tmux-navigator" },
  })
end)
