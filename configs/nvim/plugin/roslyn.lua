require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/seblyng/roslyn.nvim" },
  })

  local ok, blink = pcall(require, "blink.cmp")
  local capabilities = ok and blink.get_lsp_capabilities() or vim.lsp.protocol.make_client_capabilities()

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
