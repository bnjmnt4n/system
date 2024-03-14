local M = {}

local signs = {
  text = {},
}
for _, diag in ipairs { 'Error', 'Warn', 'Info', 'Hint' } do
  signs.text[vim.diagnostic.severity[diag:upper()]] = '▍'
end

-- Configure diagnostics.
vim.diagnostic.config {
  virtual_text = true,
  virtual_lines = false,
  signs = signs,
  severity_sort = true,
  float = {
    border = 'rounded',
  },
}
-- FIX: https://github.com/folke/lazy.nvim/issues/620
vim.diagnostic.config({ virtual_lines = false }, require('lazy.core.config').ns)

function M.on_attach(_, bufnr)
  local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  local function wrap_handler(handler)
    local overriden_handler = vim.lsp.with(handler, { border = 'rounded' })
    return function(...)
      local buf = overriden_handler(...)
      if buf then
        vim.keymap.set('n', 'K', '<cmd>wincmd p<cr>', { buffer = buf, silent = true })
      end
    end
  end

  vim.lsp.handlers['textDocument/hover'] = wrap_handler(vim.lsp.handlers.hover)
  vim.lsp.handlers['textDocument/signatureHelp'] = wrap_handler(vim.lsp.handlers.signature_help)

  map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
  map('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
  map('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
  map('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })
  map('n', 'K', vim.lsp.buf.hover, { desc = 'Hover' })
  map('n', 'gK', vim.lsp.buf.signature_help, { desc = 'Signature help' })

  map('n', '<leader>dt', vim.lsp.buf.type_definition, { desc = 'Go to type definition' })
  map('n', '<leader>e', function()
    vim.diagnostic.open_float(nil, { border = 'rounded' })
  end, { desc = 'Show line diagnostics' })
  map('n', '<leader>cl', vim.diagnostic.setloclist, { desc = 'Set location list' })

  map('n', '[d', function()
    vim.diagnostic.goto_prev { float = vim.diagnostic.is_disabled() and { border = 'rounded' } or false }
  end, { desc = 'Previous diagnostic' })
  map('n', ']d', function()
    vim.diagnostic.goto_next { float = vim.diagnostic.is_disabled() and { border = 'rounded' } or false }
  end, { desc = 'Next diagnostic' })
end

return M
