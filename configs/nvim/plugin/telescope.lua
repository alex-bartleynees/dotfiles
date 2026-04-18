require("lazyload").on_vim_enter(function()
  -- telescope and its dependencies are managed by Nix

  local telescope = require("telescope")
  local actions = require("telescope.actions")

  telescope.setup({
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown(),
      },
    },
    defaults = {
      path_display = { "smart" },
      mappings = {
        i = {
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        },
      },
    },
  })

  telescope.load_extension("fzf")
  telescope.load_extension("ui-select")

  vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
  vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
  vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
  vim.keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
  vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
  vim.keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Find diagnostics" })
  vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
  vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Open telescope with git status" })
  vim.keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "Open telescope with git branches" })
end)
