require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/rmagatti/auto-session" },
  })

  local function restore_nvim_tree()
    local nvim_tree = require("nvim-tree")
    local api = require("nvim-tree.api")
    nvim_tree.change_dir(vim.fn.getcwd())
    api.tree.focus()
  end

  vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

  require("auto-session").setup({
    auto_restore = true,
    suppressed_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
    post_restore_cmds = { restore_nvim_tree },
  })

  vim.keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
  vim.keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" })
end)
