{ config, lib, pkgs, inputs, ... }:

let
  inlay_hints_lsp_initialization_options = {
    preferences = {
      includeInlayParameterNameHints = "all";
      includeInlayParameterNameHintsWhenArgumentMatchesName = false;
      includeInlayFunctionParameterTypeHints = true;
      includeInlayVariableTypeHints = true;
      includeInlayVariableTypeHintsWhenTypeMatchesName = false;
      includeInlayPropertyDeclarationTypeHints = true;
      includeInlayFunctionLikeReturnTypeHints = true;
      includeInlayEnumMemberValueHints = true;
    };
  };
in
{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "html"
      "toml"
      "git-firefly"
      "sql"
      "lua"
      "astro"
      "nix"
    ];

    # https://zed.dev/docs/configuring-zed
    userSettings = {
      auto_update = false;
      vim_mode = true;
      vim = {
        use_multiline_find = true;
        use_smartcase_find = true;
        toggle_relative_line_numbers = true;
      };
      cursor_blink = false;
      buffer_font_size = 20;
      buffer_font_family = "Iosevka";
      buffer_font_features = {
        calt = true;
        liga = true;
      };
      soft_wrap = "editor_width";
      relative_line_numbers = true;
      double_click_in_multibuffer = "open";
      scroll_beyond_last_line = "off";
      vertical_scroll_margin = 0;
      git.inline_blame.delay_ms = 1000;
      inlay_hints = {
        enabled = true;
        show_type_hints = true;
        show_parameter_hints = true;
        show_other_hints = true;
      };
      inline_completions = {
        disabled_globs = [".env" "*.journal"];
      };
      languages = {
        JavaScript = {
          code_actions_on_format."source.fixAll.eslint" = true;
        };
        JSX = {
          code_actions_on_format."source.fixAll.eslint" = true;
        };
        TypeScript = {
          code_actions_on_format."source.fixAll.eslint" = true;
        };
        TSX = {
          code_actions_on_format."source.fixAll.eslint" = true;
        };
        Markdown = {
          remove_trailing_whitespace_on_save = true;
        };
      };
      lsp = {
        rust-analyzer = {
          binary.path_lookup = true;
        };
        typescript-language-server = {
          initialization_options = inlay_hints_lsp_initialization_options;
        };
        vstls = {
          initialization_options = inlay_hints_lsp_initialization_options;
        };
      };
      tab_bar.show = false;
      gutter.code_actions = false;
      project_panel.scrollbar.show = "never";
      assistant = {
        default_model = {
          provider = "zed.dev";
          model = "claude-3-5-sonnet-latest";
        };
        version = "2";
      };
      calls.mute_on_join = true;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      collaboration_panel.button = false;
      notification_panel.button = false;
      chat_panel.button = false;
      terminal.env = {
        EDITOR = "zed --wait";
        VISUAL = "zed --wait";
      };
    };

    # For reference:
    # https://github.com/zed-industries/zed/blob/main/assets/keymaps/default-macos.json
    # https://github.com/zed-industries/zed/blob/main/assets/keymaps/vim.json
    # userKeymaps = {};
  };
}
