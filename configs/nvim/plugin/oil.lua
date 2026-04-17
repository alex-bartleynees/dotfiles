-- Disable netrw early so oil.nvim can hijack directory browsing
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  })

  require("oil").setup({
    view_options = {
      show_hidden = true,
    },
  })

  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
end)
