{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "tmux-256color";
    shell = "${pkgs.fish}/bin/fish";
    extraConfig = ''
      # See https://github.com/tmux/tmux/issues/4162.
      set -gu default-command

      set -as terminal-features ',xterm-256color:RGB'
      set -g mouse on

      # Set prefix key to `C-a`
      unbind C-b
      set -g prefix C-a
      bind-key C-a send-prefix

      # Split panes using `|` and `-`
      bind | split-window -h
      bind - split-window -v

      # Add vim keys for switching panes
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      # Add vim keys for copy mode
      setw -g mode-keys vi
      unbind p
      bind p paste-buffer
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # Start tabs and panes at index 1
      set -g base-index 1
      setw -g pane-base-index 1

      # Renumber windows when a window is closed
      set -g renumber-windows on

      # Automatically set window title according to the running program
      set-window-option -g automatic-rename on
      set-option -g set-titles on

      # Modus Themes for Tmux
      # Auto generated with https://github.com/miikanissi/modus-themes.nvim/blob/master/lua/modus-themes/extras/tmux.lua
      set-option -g status-position "bottom"
      set-option -g status-style bg=#c8c8c8,fg=#0a0a0a
      set-option -g status-left '#[bg=#c8c8c8,fg=#0a0a0a,bold]#{?client_prefix,,  tmux  }#[bg=#3548cf,fg=#f2f2f2,bold]#{?client_prefix,  tmux  ,}'
      set-option -g status-right '#S'
      set-option -g window-status-format ' #I:#W '
      set-option -g window-status-current-format '#[bg=#3548cf,fg=#f2f2f2] #I:#W#{?window_zoomed_flag,  , }'
    '';
  };
}
