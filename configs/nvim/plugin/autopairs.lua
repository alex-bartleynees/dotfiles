require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/windwp/nvim-autopairs" },
  })

  require("nvim-autopairs").setup({
    check_ts = true,
    ts_config = {
      lua = { "string" },
      javascript = { "template_string" },
      java = false,
    },
  })
end)
