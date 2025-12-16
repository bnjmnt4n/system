local M = {}

local signs = {
  text = {},
}
for _, diag in ipairs { 'Error', 'Warn', 'Info', 'Hint' } do
  signs.text[vim.diagnostic.severity[diag:upper()]] = '▍'
end

-- Configure diagnostics.
vim.diagnostic.config {
  underline = true,
  virtual_text = false,
  virtual_lines = true,
  signs = signs,
  severity_sort = true,
}

-- See https://github.com/folke/lazy.nvim/issues/620
vim.diagnostic.config({ virtual_lines = false }, require('lazy.core.config').ns)

-- Configure inlay hints
vim.lsp.inlay_hint.enable()

M.inlay_hint_disabled_filetypes = {
  typescriptreact = true,
  typescript = true,
}

-- `on_attach` function to handle LSP setup for buffers.
local function on_attach(client, bufnr)
  -- Unset 'formatexpr' to use conform
  vim.bo[bufnr].formatexpr = nil
  if client:supports_method 'textDocument/definition' then
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = 'Go to definition' })
  end
  if client:supports_method 'textDocument/inlayHint' then
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

-- `on_detach` function to handle LSP teardown for buffers.
local function on_detach(bufnr)
  pcall(vim.keymap.del, 'n', 'gd', { buffer = bufnr })
end

-- Update mappings when registering dynamic capabilities.
local register_capability = vim.lsp.handlers['client/registerCapability']
vim.lsp.handlers['client/registerCapability'] = function(err, res, ctx)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if not client then
    return
  end

  local result = register_capability(err, res, ctx)

  for bufnr, _ in pairs(client.attached_buffers) do
    on_attach(client, bufnr)
  end

  return result
end

local lsp_group = vim.api.nvim_create_augroup('bnjmnt4n/lsp_keymaps', { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
  group = lsp_group,
  desc = 'Configure LSP keymaps',
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    on_attach(client, args.buf)
  end,
})
vim.api.nvim_create_autocmd('LspDetach', {
  group = lsp_group,
  desc = 'Configure LSP keymaps',
  callback = function(args)
    local clients = vim.lsp.get_clients { bufnr = args.buf }
    if #clients == 0 then
      on_detach(args.buf)
    end
  end,
})

return M
