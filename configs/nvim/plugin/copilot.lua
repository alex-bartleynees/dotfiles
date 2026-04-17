-- Copilot is set up here with suggestion/panel disabled so that
-- copilot-cmp (configured in nvim-cmp.lua) can handle completions instead.
require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/zbirenbaum/copilot.lua" },
    { src = "https://github.com/zbirenbaum/copilot-cmp" },
  })

  require("copilot").setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
  })

  require("copilot_cmp").setup()
end)
