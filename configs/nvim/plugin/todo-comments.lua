require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/folke/todo-comments.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
  })

  local todo_comments = require("todo-comments")
  todo_comments.setup()

  vim.keymap.set("n", "]t", function() todo_comments.jump_next() end, { desc = "Next todo comment" })
  vim.keymap.set("n", "[t", function() todo_comments.jump_prev() end, { desc = "Previous todo comment" })
end)
