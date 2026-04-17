require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/kdheepak/lazygit.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
  })

  vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<cr>", { desc = "Open lazy git" })
end)
