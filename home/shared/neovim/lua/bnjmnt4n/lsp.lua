local M = {}

local methods = vim.lsp.protocol.Methods

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

-- Configure inlay hints
vim.lsp.inlay_hint.enable()

M.inlay_hint_disabled_filetypes = {
  typescriptreact = true,
  typescript = true,
}

-- `on_attach` function to handle LSP setup for buffers.
local function on_attach(client, bufnr)
  -- Only override default "K" and "gd" keymaps if LSP supports the corresponding methods.
  if client:supports_method(methods.textDocument_hover) then
    vim.keymap.set('n', 'K', function()
      vim.lsp.buf.hover { border = 'rounded' }
    end, { buffer = bufnr, desc = 'Hover' })
  end
  if client:supports_method(methods.textDocument_definition) then
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Go to definition' })
  end
  if client:supports_method(methods.textDocument_inlayHint) then
    if vim.lsp.inlay_hint.is_enabled() then
      local filetype = vim.bo[bufnr].filetype
      if M.inlay_hint_disabled_filetypes[filetype] then
        vim.schedule(function()
          vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
        end)
      end
    end
  end
end

-- Update mappings when registering dynamic capabilities.
local register_capability = vim.lsp.handlers[methods.client_registerCapability]
vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then
    return
  end

  local result = register_capability(err, res, ctx)

  local bufnrs = vim.lsp.get_buffers_by_client_id(ctx.client_id)
  for _, bufnr in ipairs(bufnrs) do
    on_attach(client, bufnr)
  end

  return result
end

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Configure LSP keymaps',
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    on_attach(client, args.buf)
  end,
})

return M
