-- Lightbulb for code actions
vim.cmd [[
  augroup Lightbulb
    autocmd!
    autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()
  augroup end
]]
