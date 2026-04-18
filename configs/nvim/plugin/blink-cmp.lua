require("lazyload").on_vim_enter(function()
  vim.pack.add({
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
    { src = "https://github.com/fang2hou/blink-copilot" },
    { src = "https://github.com/L3MON4D3/LuaSnip", version = vim.version.range("2.*") },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
  })

  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      if ev.data.spec.name == "LuaSnip" and (ev.data.kind == "install" or ev.data.kind == "update") then
        vim.fn.jobstart({ "make", "install_jsregexp" }, { cwd = ev.data.path })
      end
    end,
  })

  require("luasnip.loaders.from_vscode").lazy_load()

  require("blink.cmp").setup({
    keymap = {
      preset = "none",
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-Space>"] = { "show", "fallback" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },
    snippets = { preset = "luasnip" },
    sources = {
      default = { "copilot", "lsp", "path", "snippets", "buffer" },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
        },
      },
    },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = {
      menu = {
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind", gap = 1 },
            { "source_name" },
          },
        },
      },
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
    },
  })
end)
