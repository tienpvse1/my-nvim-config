local api = require('nvim-tree.api')
local function opts(desc)
  return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
end

vim.keymap.set('n', '<C-n>',     api.fs.create,                         opts('Create'))
vim.keymap.set('n', '<C-d>',     api.fs.remove,                         opts('Delete'))
vim.keymap.set('n', '<C-r>',     api.fs.rename,                         opts('Rename'))



