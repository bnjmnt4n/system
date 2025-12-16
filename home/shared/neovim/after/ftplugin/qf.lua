vim.wo.number = true
vim.wo.relativenumber = false
vim.wo.numberwidth = 2
vim.wo.foldcolumn = '0'

if not vim.g.loaded_cfilter then
  vim.cmd.packadd 'cfilter'
end
