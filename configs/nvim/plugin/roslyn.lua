require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/seblyng/roslyn.nvim" },
  })

  if os.getenv("DOTNET_ROOT") or vim.fn.executable("dotnet") == 1 then
    require("roslyn").setup({
      broad_search = true,
      lock_target = false,
    })
  end
end)
