require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/seblyng/roslyn.nvim" },
  })

  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  local capabilities = cmp_nvim_lsp.default_capabilities()

  if os.getenv("DOTNET_ROOT") or vim.fn.executable("dotnet") == 1 then
    vim.lsp.config("roslyn", {
      capabilities = capabilities,
    })

    require("roslyn").setup({
      broad_search = true,
      lock_target = false,
    })
  end
end)
