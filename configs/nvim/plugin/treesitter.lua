-- nvim-treesitter (main branch) and all grammars are managed by Nix
require("lazyload").on_vim_enter(function()
  vim.api.nvim_create_autocmd("FileType", {
    callback = function()
      pcall(vim.treesitter.start)
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })

  require("nvim-ts-autotag").setup()
end)
