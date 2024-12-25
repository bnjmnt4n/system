local M = {}

local signs = {
  text = {},
}
for _, diag in ipairs { 'Error', 'Warn', 'Info', 'Hint' } do
  signs.text[vim.diagnostic.severity[diag:upper()]] = '▍'
end

-- Configure diagnostics.
vim.diagnostic.config {
  virtual_text = false,
  virtual_lines = true,
  signs = signs,
  severity_sort = true,
  float = {
    border = 'rounded',
  },
}
-- FIX: https://github.com/folke/lazy.nvim/issues/620
vim.diagnostic.config({ virtual_lines = false }, require('lazy.core.config').ns)

local hover = vim.lsp.buf.hover
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.hover = function()
  return hover {
    border = 'rounded',
  }
end
local signature_help = vim.lsp.buf.signature_help
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.buf.signature_help = function()
  return signature_help {
    border = 'rounded',
  }
end

function M.on_attach(_, bufnr)
  local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
  map('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
  map('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
  map('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })
  map('n', 'K', vim.lsp.buf.hover, { desc = 'Hover' })
  map('n', 'gK', vim.lsp.buf.signature_help, { desc = 'Signature help' })

  map('n', '<leader>dt', vim.lsp.buf.type_definition, { desc = 'Go to type definition' })
  map('n', '<leader>e', function()
    vim.diagnostic.open_float { border = 'rounded' }
  end, { desc = 'Show line diagnostics' })
  map('n', '<leader>cl', vim.diagnostic.setloclist, { desc = 'Set location list' })

  map('n', '[d', function()
    vim.diagnostic.jump {
      count = -1,
      float = not vim.diagnostic.is_enabled() and { border = 'rounded' },
    }
  end, { desc = 'Previous diagnostic' })
  map('n', ']d', function()
    vim.diagnostic.jump {
      count = 1,
      float = not vim.diagnostic.is_enabled() and { border = 'rounded' },
    }
  end, { desc = 'Next diagnostic' })
end

return M
