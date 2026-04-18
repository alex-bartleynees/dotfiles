require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/seblyng/roslyn.nvim" },
  })

  if os.getenv("DOTNET_ROOT") or vim.fn.executable("dotnet") == 1 then
    local ok, blink = pcall(require, "blink.cmp")
    local capabilities = ok and blink.get_lsp_capabilities() or vim.lsp.protocol.make_client_capabilities()

    vim.lsp.config("roslyn", {
      capabilities = capabilities,
      settings = {
        ["csharp|formatting"] = {
          dotnet_organize_imports_on_format = true,
        },
        ["csharp|inlay_hints"] = {
          csharp_enable_inlay_hints_for_implicit_variable_types = true,
          dotnet_enable_inlay_hints_for_parameters = true,
          dotnet_enable_inlay_hints_for_literal_parameters = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
          dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
        },
      },
    })

    require("roslyn").setup({
      broad_search = true,
      lock_target = false,
    })
  end
end)
