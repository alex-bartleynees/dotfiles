require("lazyload").on_vim_enter(function()
  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      if ev.data.spec.name == "nvim-treesitter" and (ev.data.kind == "install" or ev.data.kind == "update") then
        vim.cmd("TSUpdate")
      end
    end,
  })

  vim.pack.add({
    { src = "https://github.com/dlvandenberg/nvim-treesitter" },
    { src = "https://github.com/windwp/nvim-ts-autotag" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
    { src = "https://github.com/nvim-treesitter/playground" },
  })

  require("nvim-treesitter.configs").setup({
    highlight = {
      enable = true,
    },
    indent = { enable = true },
    autotag = {
      enable = true,
    },
    ensure_installed = {
      "angular",
      "json",
      "javascript",
      "typescript",
      "tsx",
      "yaml",
      "html",
      "css",
      "prisma",
      "markdown",
      "markdown_inline",
      "svelte",
      "graphql",
      "bash",
      "lua",
      "vim",
      "dockerfile",
      "gitignore",
      "query",
      "vimdoc",
      "c",
    },
    sync_install = false,
    auto_install = true,
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
  })
end)
