-- LSP

-- TODO: look for inspiration in the following configurations
-- - https://phelipetls.github.io/posts/configuring-eslint-to-work-with-neovim-lsp/
-- - https://elianiva.my.id/post/my-nvim-lsp-setup
-- - https://github.com/lukas-reineke/dotfiles/tree/master/vim/lua/lsp
-- - https://github.com/lucax88x/configs/tree/master/dotfiles/.config/nvim/lua/lt/lsp

local lsp_formatting_augroup = vim.api.nvim_create_augroup('LspFormatting', {})

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
      vim.keymap.set('n', 'K', '<cmd>wincmd p<cr>', { buffer = buf, noremap = true, silent = true })
    end
  end
  local overridden_signature_help = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single' })
  vim.lsp.handlers['textDocument/signatureHelp'] = function(...)
    local buf = overridden_signature_help(...)
    -- TODO: is this correct?
    if buf then
      vim.keymap.set('n', 'K', '<cmd>wincmd p<cr>', { buffer = buf, noremap = true, silent = true })
    end
  end

  -- Format on save: https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Formatting-on-save
  if client.supports_method 'textDocument/formatting' then
    vim.api.nvim_clear_autocmds { group = lsp_formatting_augroup, buffer = bufnr }
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = lsp_formatting_augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format {
          bufnr = bufnr,
          filter = function(cl)
            return cl.name == 'null-ls'
          end,
        }
      end,
    })
  end

  local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.buffer = bufnr
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
  map('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
  map('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
  map('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references', noremap = true })
  map('n', 'K', vim.lsp.buf.hover, { desc = 'Hover' })
  map('n', '<c-k>', vim.lsp.buf.signature_help, { desc = 'Signature help' })
  map('n', '<leader>cr', vim.lsp.buf.rename, { desc = 'Rename variable' })
  -- TODO: confirm keybindings?
  map('n', '<leader>D', vim.lsp.buf.type_definition, { desc = 'Go to type definition' })
  map('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show line diagnostics' })
  map('n', '<leader>cl', vim.diagnostic.setloclist, { desc = 'Set location list' })

  map('n', '[d', function()
    vim.diagnostic.goto_prev { popup_opts = { border = 'single' } }
  end, { desc = 'Previous diagnostic' })
  map('n', ']d', function()
    vim.diagnostic.goto_next { popup_opts = { border = 'single' } }
  end, { desc = 'Next diagnostic' })
end

return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    keys = {
      { '<leader>li', '<cmd>LspInfo<cr>', desc = 'LSP information' },
      { '<leader>lr', '<cmd>LspRestart<cr>', desc = 'Restart LSP servers' },
      { '<leader>ls', '<cmd>LspStart<cr>', desc = 'Start LSP servers' },
      { '<leader>lt', '<cmd>LspStop<cr>', desc = 'Stop LSP servers' },
      { '<leader>lwa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>', desc = 'Add workspace folder' },
      { '<leader>lwr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>', desc = 'Remove workspace folder' },
      {
        '<leader>lwl',
        '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>',
        desc = 'List workspace folders',
      },
    },
    config = function()
      local nvim_lsp = require 'lspconfig'

      -- nvim-cmp supports additional completion capabilities
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Enable the following language servers
      local servers = { 'clangd', 'cssls', 'gopls', 'html', 'ocamllsp', 'pyright', 'rnix', 'zls' }

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

      nvim_lsp.lua_ls.setup {
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
            format = {
              enable = true,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }

      -- ESLint
      nvim_lsp.eslint.setup {
        on_attach = function(client, bufnr)
          vim.api.nvim_clear_autocmds { group = lsp_formatting_augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = lsp_formatting_augroup,
            buffer = bufnr,
            command = 'EslintFixAll',
          })
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

      -- Haskell
      nvim_lsp.hls.setup {
        cmd = { 'haskell-language-server', '--lsp' },
        on_attach = on_attach,
        capabilities = capabilities,
      }
    end,
  },

  -- Nvim-based language server + diagnostics
  {
    'jose-elias-alvarez/null-ls.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = function()
      local null_ls = require 'null-ls'
      return {
        on_attach = on_attach,
        sources = {
          null_ls.builtins.formatting.stylua,
          require 'typescript.extensions.null-ls.code-actions',
        },
      }
    end,
  },

  -- TypeScript
  {
    'jose-elias-alvarez/typescript.nvim',
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    opts = function()
      return {
        disable_commands = false,
        debug = false,
        go_to_source_definition = {
          fallback = true,
        },
        server = {
          on_attach = function(client, bufnr)
            if client.config.flags then
              client.config.flags.allow_incremental_sync = true
            end
            -- Prevent formatting with `tsserver` so `null-ls` can do the formatting
            client.server_capabilities.documentFormattingProvider = false

            on_attach(client, bufnr)
          end,
          capabilities = require('cmp_nvim_lsp').default_capabilities(),
        },
      }
    end,
  },

  -- Better Rust tools
  {
    'simrat39/rust-tools.nvim',
    ft = 'rust',
    opts = {
      tools = {
        autoSetHints = true,
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
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          vim.keymap.set('n', 'K', '<cmd>RustHoverActions<cr>', { buffer = bufnr, noremap = true, silent = true })
        end,
      },
    },
  },

  -- Java
  {
    'mfussenegger/nvim-jdtls',
    ft = 'java',
    config = function()
      SetupJdtls = function()
        require('jdtls').start_or_attach {
          cmd = { 'jdt-language-server' },
          on_attach = on_attach,
          capabilities = require('cmp_nvim_lsp').default_capabilities(),
        }
      end

      local java_lsp_augroup = vim.api.nvim_create_augroup('JavaLspSetup', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        group = java_lsp_augroup,
        pattern = 'java',
        callback = SetupJdtls,
      })
    end,
  },
}
