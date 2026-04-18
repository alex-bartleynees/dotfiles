-- nvim-treesitter and all grammars are managed by Nix
require("lazyload").on_vim_enter(function()
  require("nvim-treesitter.configs").setup({
    highlight = { enable = true },
    indent = { enable = true },
    autotag = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
  })
end)
