local M = {}
local vim_enter_queue = {}
local override_queue = {}
local vim_entered = false

local function drain()
  for _, cb in ipairs(vim_enter_queue) do
    if cb.sync then cb.fn() end
  end
  for _, cb in ipairs(vim_enter_queue) do
    if not cb.sync then
      vim.schedule(cb.fn)
    end
  end
  for _, cb in ipairs(override_queue) do
    vim.schedule(cb)
  end
end

function M.on_vim_enter(fn, opts)
  opts = opts or {}
  if vim_entered then
    if opts.sync then fn()
    else vim.schedule(fn) end
    return
  end
  table.insert(vim_enter_queue, { fn = fn, sync = opts.sync })
end

function M.on_override(fn)
  if vim_entered then
    vim.schedule(fn)
    return
  end
  table.insert(override_queue, fn)
end

vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim_entered = true
    drain()
  end,
})

return M
