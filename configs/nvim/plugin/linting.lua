require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/mfussenegger/nvim-lint" },
  })

  local lint = require("lint")

  lint.linters_by_ft = {
    javascript = { "eslint_d" },
    typescript = { "eslint_d" },
    javascriptreact = { "eslint_d" },
    typescriptreact = { "eslint_d" },
    svelte = { "eslint_d" },
    python = { "ruff" },
  }

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    callback = function()
      lint.try_lint()
    end,
  })

  vim.keymap.set("n", "<leader>l", function()
    lint.try_lint()
  end, { desc = "Trigger linting for current file" })
end)
