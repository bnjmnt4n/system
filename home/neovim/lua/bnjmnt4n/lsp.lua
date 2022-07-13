-- LSP

-- TODO: look for inspiration in the following configurations
-- - https://phelipetls.github.io/posts/configuring-eslint-to-work-with-neovim-lsp/
-- - https://elianiva.my.id/post/my-nvim-lsp-setup
-- - https://github.com/lukas-reineke/dotfiles/tree/master/vim/lua/lsp
-- - https://github.com/lucax88x/configs/tree/master/dotfiles/.config/nvim/lua/lt/lsp

local nvim_lsp = require 'lspconfig'

local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  })

  local overridden_hover = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' })
  vim.lsp.handlers['textDocument/hover'] = function(...)
    local buf = overridden_hover(...)
    -- TODO: is this correct?
    if buf then
      vim.keymap.set('n', 'K', '<cmd>wincmd p<CR>', { buffer = buf, noremap = true, silent = true })
    end
  end
  local overridden_signature_help = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single' })
  vim.lsp.handlers['textDocument/signatureHelp'] = function(...)
    local buf = overridden_signature_help(...)
    -- TODO: is this correct?
    if buf then
      vim.keymap.set('n', 'K', '<cmd>wincmd p<CR>', { buffer = buf, noremap = true, silent = true })
    end
  end

  -- Format on save: https://github.com/jose-elias-alvarez/null-ls.nvim#how-do-i-format-files-on-save
  if client.resolved_capabilities.document_formatting then
    vim.cmd [[
      augroup LspFormatting
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
      augroup END
    ]]
  end

  require('which-key').register({
    g = {
      D = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'Go to declaration' },
      d = { '<cmd>lua vim.lsp.buf.definition()<CR>', 'Go to definition' },
      i = { '<cmd>lua vim.lsp.buf.implementation()<CR>', 'Go to implementation' },
      r = { '<cmd>lua vim.lsp.buf.references()<CR>', 'Go to references' },
    },
    K = { '<cmd>lua vim.lsp.buf.hover()<CR>', 'Hover' },
    ['<C-k>'] = { '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Singature help' },
    ['<leader>'] = {
      cr = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename variable' },
      -- TODO: keybindings
      D = { '<cmd>lua vim.lsp.buf.type_definition()<CR>', 'Go to type definition' },
      e = { '<cmd>lua vim.diagnostic.open_float()<CR>', 'Show line diagnostics' },
      cl = { '<cmd>lua vim.diagnostic.set_loclist()<CR>', 'Set location list' },
    },
    ['[d'] = {
      '<cmd>lua vim.diagnostic.goto_prev({ popup_opts = { border = "single" } })<CR>',
      'Previous diagnostic',
    },
    [']d'] = {
      '<cmd>lua vim.diagnostic.goto_next({ popup_opts = { border = "single" } })<CR>',
      'Next diagnostic',
    },
  }, {
    buffer = bufnr,
  })
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- null-ls setup
local null_ls = require 'null-ls'
null_ls.setup {
  on_attach = on_attach,
  sources = {
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.formatting.eslint_d,
  },
}

-- Enable the following language servers
local servers = { 'clangd', 'cssls', 'gopls', 'html', 'pyright', 'rnix', 'zls' }

for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Lua
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

nvim_lsp.sumneko_lua.setup {
  cmd = { 'lua-language-server' },
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = runtime_path,
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

-- TypeScript
nvim_lsp.tsserver.setup {
  -- Needed for inlay hints.
  init_options = require('nvim-lsp-ts-utils').init_options,
  on_attach = function(client, bufnr)
    if client.config.flags then
      client.config.flags.allow_incremental_sync = true
    end
    -- Prevent formatting with `tsserver` so `null-ls` can do the formatting
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false

    local ts_utils = require 'nvim-lsp-ts-utils'
    ts_utils.setup {
      disable_commands = false,
      enable_import_on_completion = true,
      import_all_timeout = 5000,

      -- Disable inlay hints by default.
      auto_inlay_hints = false,
    }

    -- Fixes code action ranges
    ts_utils.setup_client(client)

    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
}

-- Tailwind
nvim_lsp.tailwindcss.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          { 'classNames\\(([^)]*)\\)', '"([^"]*)"' },
        },
      },
    },
  },
}

-- Rust
require('rust-tools').setup {
  tools = {
    autoSetHints = true,
    hover_with_actions = true,
    runnables = {
      use_telescope = true,
    },
    inlay_hints = {
      show_parameter_hints = true,
      parameter_hints_prefix = ' <-',
      other_hints_prefix = ' =>',
    },
  },
  server = {
    on_attach = on_attach,
  },
}

-- Java
SetupJdtls = function()
  require('jdtls').start_or_attach {
    cmd = { 'jdt-language-server' },
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

vim.cmd [[
  augroup JavaLspSetup
    au!
    au FileType java lua SetupJdtls()
  augroup end
]]

-- Haskell
nvim_lsp.hls.setup {
  cmd = { 'haskell-language-server', '--lsp' },
  on_attach = on_attach,
  capabilities = capabilities,
}
