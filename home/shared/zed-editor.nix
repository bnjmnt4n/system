{...}: {
  programs.zed-editor = {
    enable = true;
    extensions = [
      "astro"
      "git-firefly"
      "html"
      "lua"
      "nix"
      "sql"
      "toml"
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
      load_direnv = "shell_hook";
      features = {
        edit_prediction_provider = "zed";
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
        edit_debounce_ms = 500;
      };
      edit_predictions = {
        mode = "eager";
        disabled_globs = [
          "**/*.journal"
        ];
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
      };
      diagnostics = {
        enable = true;
        inline = {
          enabled = true;
          padding = 4;
        };
      };
      assistant = {
        default_model = {
          provider = "zed.dev";
          model = "claude-3-7-sonnet-latest";
        };
        version = "2";
      };
      terminal.env = {
        EDITOR = "zeditor --wait";
        VISUAL = "zeditor --wait";
      };
      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      # UI
      cursor_blink = false;
      buffer_font_size = 20;
      buffer_font_family = "Iosevka";
      buffer_font_features = {
        calt = true;
        liga = true;
      };
      theme = {
        "mode" = "system";
        "light" = "One Light";
        "dark" = "One Dark";
      };
      gutter.code_actions = false;
      project_panel.scrollbar.show = "never";
      show_call_status_icon = false;
      calls.mute_on_join = true;
      collaboration_panel.button = false;
      notification_panel.button = false;
      chat_panel.button = "when_in_call";
    };

    # For reference:
    # https://github.com/zed-industries/zed/blob/main/assets/keymaps/default-macos.json
    # https://github.com/zed-industries/zed/blob/main/assets/keymaps/vim.json
    userKeymaps = [
      {
        "context" = "EmptyPane || SharedScreen || Editor && VimControl && !VimWaiting && !menu";
        "bindings" = {
          "space space" = "file_finder::Toggle";
          "space f f" = "file_finder::Toggle";
          "space ," = "tab_switcher::Toggle";
          "space /" = "workspace::NewSearch";
          "space o l" = "workspace::ToggleLeftDock";
          "space o r" = "workspace::ToggleRightDock";
          "space o a" = "assistant::ToggleFocus";
          "space o c" = "collab_panel::ToggleFocus";
          "space o o" = "outline_panel::ToggleFocus";
          "space o f" = "project_panel::ToggleFocus";
          "space o p" = "projects::OpenRecent";
          "space o t" = "terminal_panel::ToggleFocus";
          "space g g" = "git::Diff";
          "space w v" = "pane::SplitRight";
          "space w h" = "workspace::ActivatePaneLeft";
          "space w l" = "workspace::ActivatePaneRight";
          "space w k" = "workspace::ActivatePaneUp";
          "space w j" = "workspace::ActivatePaneDown";
          "space w z" = "workspace::ToggleZoom";
          "space q q" = "zed::Quit";
          "ctrl-w z" = "workspace::ToggleZoom";
          "ctrl-w t" = "terminal_panel::ToggleFocus";
          "ctrl-`" = "workspace::ToggleBottomDock";
        };
      }
      {
        "context" = "Dock || Terminal || Editor";
        "bindings" = {
          "ctrl-h" = "workspace::ActivatePaneLeft";
          "ctrl-l" = "workspace::ActivatePaneRight";
          "ctrl-k" = "workspace::ActivatePaneUp";
          "ctrl-j" = "workspace::ActivatePaneDown";
          "ctrl-`" = "workspace::ToggleBottomDock";
        };
      }
      {
        "context" = "Editor && VimControl && !VimWaiting && !VimCount && !menu";
        "bindings" = {
          "j" = ["vim::Down" {"display_lines" = true;}];
          "k" = ["vim::Up" {"display_lines" = true;}];
        };
      }
      {
        "context" = "Editor && VimControl && !VimWaiting && !menu";
        "bindings" = {
          "enter" = "editor::SelectLargerSyntaxNode";
          "backspace" = "editor::SelectSmallerSyntaxNode";
          "g p d" = "editor::GoToDefinitionSplit";
          "g p t" = "editor::GoToTypeDefinitionSplit";
          "g r" = "editor::FindAllReferences";
          "shift-k" = "editor::Hover";
          "alt-j" = "editor::MoveLineDown";
          "alt-k" = "editor::MoveLineUp";
          "ctrl-]" = "editor::NextEditPrediction";
          "ctrl-[" = "editor::PreviousEditPrediction";
          "space c a" = "editor::ToggleCodeActions";
          "space c f" = "editor::Format";
          "space c r" = "editor::Rename";
          "space f s" = "workspace::Save";
          "space h b" = "git::Blame";
          "space d" = "diagnostics::Deploy";
          "space g y" = "editor::CopyPermalinkToLine";
          "space g shift-y" = "editor::OpenPermalinkToLine";
        };
      }
      {
        "context" = "vim_mode == insert && !menu";
        "bindings" = {
          "ctrl-]" = "editor::NextEditPrediction";
          "ctrl-[" = "editor::PreviousEditPrediction";
          "ctrl-n" = "editor::ShowCompletions";
        };
      }
      {
        "context" = "vim_mode == visual";
        "bindings" = {
          "shift-s" = ["vim::PushAddSurrounds" {}];
        };
      }
      {
        "context" = "Terminal";
        "bindings" = {
          "ctrl-u" = "terminal::Clear";
        };
      }
      {
        "context" = "OutlinePanel && not_editing";
        "bindings" = {
          "j" = "menu::SelectNext";
          "k" = "menu::SelectPrevious";
          "shift-g" = "menu::SelectLast";
          "g g" = "menu::SelectFirst";
        };
      }
    ];
  };
}
