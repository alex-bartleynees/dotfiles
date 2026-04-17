require("lazyload").on_vim_enter(function()
  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      if ev.data.spec.name == "CopilotChat.nvim" and (ev.data.kind == "install" or ev.data.kind == "update") then
        vim.fn.jobstart({ "make", "tiktoken" }, { cwd = ev.data.path })
      end
    end,
  })

  vim.pack.add({
    { src = "https://github.com/CopilotC-Nvim/CopilotChat.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
  })

  require("CopilotChat").setup({
    model = "gpt-5",
    temperature = 0.1,
    window = {
      layout = "vertical",
      width = 0.5,
    },
    auto_insert_mode = true,
  })
end)
