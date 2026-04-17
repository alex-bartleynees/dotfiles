require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/gbprod/substitute.nvim" },
  })

  local substitute = require("substitute")
  substitute.setup()

  vim.keymap.set("n", "s", substitute.operator, { desc = "Substitute with motion" })
  vim.keymap.set("n", "ss", substitute.line, { desc = "Substitute line" })
  vim.keymap.set("n", "S", substitute.eol, { desc = "Substitute to end of line" })
  vim.keymap.set("x", "s", substitute.visual, { desc = "Substitute in visual mode" })
end)
