return {
  {
    "towolf/vim-helm",
    ft = { "yaml", "yml" },
    event = "VeryLazy",
    config = function()
      -- Set up auto-detection for Helm files
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = {
          -- Adjust these patterns to match your project structure
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
          "helmfile*.yml"
        },
        callback = function()
          -- Set filetype to helm
          vim.bo.filetype = "helm"
        end,
      })
    end,
  }
}
