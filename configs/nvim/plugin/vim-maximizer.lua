require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/szw/vim-maximizer" },
  })

  vim.keymap.set("n", "<leader>sm", "<cmd>MaximizerToggle<CR>", { desc = "Maximize/minimize a split" })
end)
