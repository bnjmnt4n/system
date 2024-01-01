-- LSP

-- TODO: look for inspiration in the following configurations
-- - https://github.com/lukas-reineke/dotfiles/tree/master/vim/lua/lsp
-- - https://github.com/lucax88x/configs/tree/master/dotfiles/.config/nvim/lua/lt/lsp

local on_attach = require('bnjmnt4n.lsp').on_attach

return {
  -- LSP configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Delay before displaying diagnostics
      {
        'yorickpeterse/nvim-dd',
        main = 'dd',
        config = true,
      },

      -- Diagnostic lines
      {
        'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
        config = true,
      },
    },
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
      local servers = { 'astro', 'clangd', 'cssls', 'eslint', 'html', 'ocamllsp', 'pyright', 'rnix', 'zls' }

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
              globals = {
                'vim', -- Neovim
                'hs', -- Hammerspoon
                -- LuaSnip
                's',
                'fmt',
                'c',
                'd',
                'i',
                'l',
                'r',
                'sn',
                't',
              },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false,
            },
            format = { enable = false },
            telemetry = { enable = false },
          },
        },
      }

      -- Tailwind
      nvim_lsp.tailwindcss.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          tailwindCSS = {
            experimental = {
              classRegex = {
                { 'classNames\\(([^)]*)\\)', 'cva\\(([^)]*)\\)', '"([^"]*)"' },
              },
            },
          },
        },
      }

      -- JSON
      nvim_lsp.jsonls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          json = {
            validate = { enable = true },
            format = { enable = true },
          },
        },
        on_new_config = function(config)
          config.settings.json.schemas = require('schemastore').json.schemas()
        end,
      }

      -- Go
      nvim_lsp.gopls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
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

  -- LSP status
  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    opts = {
      progress = {
        poll_rate = 0.5,
        ignore_done_already = true,
        ignore_empty_message = true,
      },
    },
  },

  -- Incremental rename
  {
    'smjonas/inc-rename.nvim',
    config = true,
    keys = {
      {
        '<leader>cr',
        function()
          return ':IncRename ' .. vim.fn.expand '<cword>'
        end,
        desc = 'Rename variable',
        expr = true,
      },
    },
  },

  -- Code actions preview
  {
    'aznhe21/actions-preview.nvim',
    -- stylua: ignore
    keys = {
      { '<leader>ca', function() require('actions-preview').code_actions() end, desc = 'Code actions' },
    },
    opts = {
      telescope = {
        make_value = nil,
        make_make_display = nil,
      },
    },
  },

  -- TypeScript
  {
    'pmizio/typescript-tools.nvim',
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {
      on_attach = on_attach,
      settings = {
        expose_as_code_action = 'all',
        tsserver_file_preferences = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  },

  -- Better Rust tools
  {
    'simrat39/rust-tools.nvim',
    ft = 'rust',
    opts = function()
      return {
        tools = {
          executor = require('rust-tools.executors').toggleterm,
          inlay_hints = {
            auto = false,
          },
          hover_actions = {
            border = 'rounded',
          },
        },
        server = {
          on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            vim.keymap.set('n', 'K', '<cmd>RustHoverActions<cr>', { buffer = bufnr, silent = true })
          end,
        },
      }
    end,
  },

  {
    'b0o/SchemaStore.nvim',
    -- Loaded by jsonls when needed.
    lazy = true,
  },
}
