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
    cmd = { 'LspInfo', 'LspStart', 'LspStop', 'LspRestart', 'LspLog' },
    -- stylua: ignore
    keys = {
      { '<leader>li', '<cmd>LspInfo<cr>', desc = 'LSP information' },
      { '<leader>ls', '<cmd>LspStart<cr>', desc = 'Start LSP servers' },
      { '<leader>lt', '<cmd>LspStop<cr>', desc = 'Stop LSP servers' },
      { '<leader>lr', '<cmd>LspRestart<cr>', desc = 'Restart LSP servers' },
      { '<leader>ll', '<cmd>LspLog<cr>', desc = 'LSP log' },
      { '<leader>lwa', vim.lsp.buf.add_workspace_folder, desc = 'Add workspace folder' },
      { '<leader>lwr', vim.lsp.buf.remove_workspace_folder, desc = 'Remove workspace folder' },
      {
        '<leader>lwl',
        function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end,
        desc = 'List workspace folders',
      },
    },
    config = function()
      local runtime_path = vim.split(package.path, ';')
      table.insert(runtime_path, 'lua/?.lua')
      table.insert(runtime_path, 'lua/?/init.lua')

      local servers = {
        astro = {},
        clangd = {},
        cssls = {},
        eslint = {},
        gopls = {
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
        },
        html = {},
        jsonls = {
          settings = {
            json = {
              validate = { enable = true },
              format = { enable = false },
            },
          },
          on_new_config = function(config)
            config.settings.json.schemas = config.settings.json.schemas or {}
            vim.list_extend(config.settings.json.schemas, require('schemastore').json.schemas())
          end,
        },
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
                path = runtime_path,
              },
              diagnostics = {
                globals = {
                  'vim', -- Neovim
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
        },
        nixd = {
          settings = {
            nixd = {
              options = {
                home_manager = {
                  -- TODO: does this need to be platform specific?
                  expr = '(builtins.getFlake "my").homeConfigurations."bnjmnt4n@macbook".options',
                },
              },
            },
          },
        },
        pyright = {},
        tailwindcss = {
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  { 'classNames\\(([^)]*)\\)', '"([^"]*)"' },
                  { 'cva\\(([^)]*)\\)', '["\'`]([^"\'`]*).*?["\'`]' },
                  { 'cx\\(([^)]*)\\)', "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                },
              },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              validate = { enable = true },
              format = { enable = false },
              schemastore = {
                -- Using the schemastore plugin instead.
                enable = false,
                url = '',
              },
            },
          },
          on_new_config = function(config)
            config.settings.yaml.schemas = config.settings.yaml.schemas or {}
            vim.list_extend(config.settings.yaml.schemas, require('schemastore').yaml.schemas())
          end,
        },
        zls = {},
      }

      local nvim_lsp = require 'lspconfig'
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

      for server, settings in pairs(servers) do
        nvim_lsp[server].setup(vim.tbl_deep_extend('error', {
          capabilities = capabilities,
          silent = true,
        }, settings))
      end
    end,
  },

  -- LSP status
  {
    'j-hui/fidget.nvim',
    event = 'LspAttach',
    opts = {
      progress = {
        poll_rate = 0.5,
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
      { '<leader>ca', function() require('actions-preview').code_actions() end, mode = { 'n', 'x' }, desc = 'Code actions' },
    },
    opts = function()
      return {
        telescope = {
          sorting_strategy = 'ascending',
          layout_strategy = 'vertical',
          layout_config = {
            width = 0.8,
            height = 0.9,
            prompt_position = 'top',
            preview_cutoff = 20,
            preview_height = function(_, _, max_lines)
              return max_lines - 15
            end,
          },
        },
        highlight_command = {
          require('actions-preview.highlight').delta(),
        },
      }
    end,
  },

  -- TypeScript
  {
    'pmizio/typescript-tools.nvim',
    ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    opts = {
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

  -- Rust
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false,
  },

  -- JSON schemas
  {
    'b0o/SchemaStore.nvim',
    -- Loaded by jsonls/yamlls when needed.
    lazy = true,
  },
}
