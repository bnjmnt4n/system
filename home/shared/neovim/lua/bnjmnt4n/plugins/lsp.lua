return {
  -- LSP configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Delay before displaying diagnostics
      {
        'yorickpeterse/nvim-dd',
        main = 'dd',
        opts = {},
      },
    },
    event = { 'VeryLazy' },
    cmd = { 'LspInfo', 'LspStart', 'LspStop', 'LspRestart', 'LspLog' },
    -- stylua: ignore
    keys = {
      { '<leader>li', '<cmd>checkhealth vim.lsp<cr>', desc = 'LSP information' },
      { '<leader>ls', '<cmd>lsp start<cr>', desc = 'Start LSP servers' },
      { '<leader>lt', '<cmd>lsp stop<cr>', desc = 'Stop LSP servers' },
      { '<leader>lr', '<cmd>lsp restart<cr>', desc = 'Restart LSP servers' },
      { '<leader>ll', function() vim.cmd(string.format('tabnew %s', vim.lsp.log.get_filename())) end, desc = 'LSP log' },
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
      local jsts_settings = {
        suggest = { completeFunctionCalls = true },
        inlayHints = {
          parameterNames = { enabled = 'all' },
          parameterTypes = { enabled = true },
          variableTypes = { enabled = true },
          propertyDeclarationTypes = { enabled = true },
          functionLikeReturnTypes = { enabled = true },
          enumMemberValues = { enabled = true },
        },
      }

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
              format = { enable = true },
            },
          },
          before_init = function(_, config)
            -- Can't assign new table because of
            -- https://github.com/neovim/neovim/issues/27740#issuecomment-1978629315
            config.settings.json.schemas = config.settings.json.schemas or {}
            vim.list_extend(config.settings.json.schemas, require('schemastore').json.schemas())
          end,
        },
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT',
                path = {
                  'lua/?.lua',
                  'lua/?/init.lua',
                },
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  vim.api.nvim_get_runtime_file('', true),
                },
              },
              format = { enable = false },
              telemetry = { enable = false },
            },
          },
        },
        nixd = {
          settings = {
            nixd = {
              formatting = {
                command = { 'alejandra' },
              },
            },
          },
        },
        pyright = {},
        tailwindcss = {},
        -- tsgo = {},
        vtsls = {
          settings = {
            typescript = jsts_settings,
            javascript = jsts_settings,
            vtsls = {
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                -- For completion performance.
                completion = { enableServerSideFuzzyMatch = true },
              },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              validate = { enable = true },
              format = { enable = true },
              schemastore = {
                -- Using the schemastore plugin instead.
                enable = false,
                url = '',
              },
            },
          },
          before_init = function(_, config)
            -- Can't assign new table because of
            -- https://github.com/neovim/neovim/issues/27740#issuecomment-1978629315
            config.settings.yaml.schemas = config.settings.yaml.schemas or {}
            vim.list_extend(config.settings.yaml.schemas, require('schemastore').yaml.schemas())
          end,
        },
        zizmor = {
          cmd = { 'zizmor', '--lsp' },
          filetypes = { 'yaml' },
          root_markers = { '.github' },
          capabilities = {
            textDocument = {
              didOpen = { dynamicRegistration = true },
              didChange = { dynamicRegistration = true },
              didSave = { dynamicRegistration = true },
              didClose = { dynamicRegistration = true },
            },
            workspace = {
              didChangeConfiguration = { dynamicRegistration = true },
            },
          },
        },
        zls = {},
      }

      for server_name, config in pairs(servers) do
        vim.lsp.config(server_name, config)
        vim.lsp.enable(server_name)
      end
    end,
  },

  -- LSP status
  {
    'j-hui/fidget.nvim',
    event = { 'LspAttach' },
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
    cmd = { 'IncRename' },
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
    opts = {},
  },

  -- Code actions preview
  {
    'aznhe21/actions-preview.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
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
      }
    end,
  },

  -- Rust
  {
    'mrcjkb/rustaceanvim',
    version = '^6',
    lazy = false,
  },

  -- JSON schemas
  {
    'b0o/SchemaStore.nvim',
    -- Loaded by jsonls/yamlls when needed.
    lazy = true,
  },
}
