vim.o.commentstring = 'JJ: %s'
vim.o.textwidth = 72
vim.o.formatexpr = ''
vim.opt_local.formatoptions:append { 't', 'l' }
vim.opt_local.formatoptions:remove { 'c', 'r', 'o', 'q' }
