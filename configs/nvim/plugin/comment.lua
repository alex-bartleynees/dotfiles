require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/numToStr/Comment.nvim" },
    { src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" },
  })

  local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

  require("Comment").setup({
    pre_hook = ts_context_commentstring.create_pre_hook(),
  })
end)
