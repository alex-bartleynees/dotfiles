require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/towolf/vim-helm" },
  })

  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = {
      "*/templates/*.yaml",
      "*/templates/*.yml",
      "*/templates/*.tpl",
      "templates/**/*",
      "*/charts/*/templates/*",
      "values.yaml",
      "values.yml",
      "Chart.yaml",
      "Chart.yml",
      "helmfile*.yaml",
      "helmfile*.yml",
    },
    callback = function()
      vim.bo.filetype = "helm"
    end,
  })
end)
