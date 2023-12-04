{  pkgs, ... }:
let
  inherit pkgs;
  tmux-nova = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "nova";
    name = "tmux-noova";
    version = "latest";
    src = pkgs.fetchgit {
      url = "https://github.com/o0th/tmux-nova.git";
      rev = "7103fd78fec47c74e9a431c50e9543d0486d5201";
      sha256 = "sha256-1A7pnMMOwp1K7+WAAKbTqrMpm/wcorui6TQDHm8Xzd8=";
    };
  };
in
{
  programs.tmux.enable = true;
  programs.tmux.prefix = "C-Space";
  programs.tmux.extraConfig = ''
    set -ga terminal-overrides ",screen-256color*:Tc"
    set-option -g default-terminal "screen-256color"
    set -s escape-time 0

    # Copy mode on mouse scroll
    set -g mouse on
    setw -g mode-keys vi
    set -sg escape-time 0

    set -g base-index 1
    set -g pane-base-index 1
    set-window-option -g pane-base-index 1
    set-option -g renumber-windows on

    # start with window 1 (instead of 0)
    set -g base-index 1

    # start with pane 1
    set -g pane-base-index 1

    bind '"' split-window -v -c "#{pane_current_path}"
    bind % split-window -h -c "#{pane_current_path}"

    # remap prefix to ctrl-space
    unbind C-b
    set -g prefix C-Space
    bind C-Space send-prefix

    # switch windows alt+number
    bind-key -n M-1 select-window -t 1
    bind-key -n M-2 select-window -t 2
    bind-key -n M-3 select-window -t 3
    bind-key -n M-4 select-window -t 4
    bind-key -n M-5 select-window -t 5
    bind-key -n M-6 select-window -t 6
    bind-key -n M-7 select-window -t 7
    bind-key -n M-8 select-window -t 8
    bind-key -n M-9 select-window -t 9

    bind-key -n M-n new-window
    bind-key -n M-x kill-window

    # moving between panes
    bind h select-pane -L
    bind j select-pane -D
    bind k select-pane -U
    bind l select-pane -R
  '';

  programs.tmux.plugins = [
    {
      plugin = tmux-nova;
      extraConfig = ''
        set -g @nova-nerdfonts true
        set -g @nova-segment-mode "#{?client_prefix,cmd,π}"
        set -g @nova-segment-mode-colors "#98bb6c #1f1f28"
        set -g @nova-status-style-bg "#1f1f28"
        set -g @nova-status-style-fg "#c0caf5"
        set -g @nova-status-style-active-bg "#7e9cd8"
        set -g @nova-status-style-active-fg "#1f1f28"
        set -g @nova-pane "[#I#{?pane_in_mode, #{pane_mode},}] #W"
        set -g @nova-rows 0
        set -g @nova-segments-0-left "mode"
      '';
    }
  ];
}
