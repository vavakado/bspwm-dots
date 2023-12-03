{ config, pkgs, fetchgit, ... }:
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
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "vavakado";
  home.homeDirectory = "/home/vavakado";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
  programs.lazygit.enable = true;
  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    ".config/bspwm/bspwmrc" = { 
      text = ''
        #! /bin/sh
        pgrep -x sxhkd > /dev/null || sxhkd &
        #feh --bg-scale /home/vavakado/wall.jpg
        feh --bg-scale /home/vavakado/Downloads/wallhaven-q2vzd7_1920x1080.png
        pipewire &
        picom --config ~/.config/picom/picom.sample.conf &
        ~/.config/polybar/launch.sh &

        bspc monitor -d I II III IV V VI

        bspc config border_width         3
        bspc config window_gap           0
        bspc config focused_border_color '#658594'
        bspc config normal_border_color  '#1F1F28'
        bspc config split_ratio          0.52
        bspc config borderless_monocle   true
        bspc config gapless_monocle      true
        bspc config focus_follows_pointer true
      '';
      executable = true;
    };
 
    ".config/sxhkd/sxhkdrc" = {
      text = ''
        #
        # wm independent hotkeys
        #

        # terminal emulator
        super + Return
        	alacritty

        # program launcher
        super + d
        	rofi -show drun
        super + shift + d
        	rofi -show run
	
        # make sxhkd reload its configuration files:
        super + Escape
        	pkill -USR1 -x sxhkd

        #
        # bspwm hotkeys
        #

        # quit/restart bspwm
        super + alt + {q,r}
        	bspc {quit,wm -r}

        # close and kill
        super + {_,shift + }q
        	bspc node -{c,k}

        # alternate between the tiled and monocle layout
        super + m
        	bspc desktop -l next

        # send the newest marked node to the newest preselected node
        super + y
        	bspc node newest.marked.local -n newest.!automatic.local

        # swap the current node and the biggest window
        super + g
        	bspc node -s biggest.window

        #
        # state/flags
        #

        # set the window state
        super + {t,shift + t,s,f}
        	bspc node -t {tiled,pseudo_tiled,floating,fullscreen}

        # set the node flags
        super + ctrl + {m,x,y,z}
        	bspc node -g {marked,locked,sticky,private}

        #
        # focus/swap
        #

        # focus the node in the given direction
        super + {_,shift + }{h,j,k,l}
        	bspc node -{f,s} {west,south,north,east}

        # focus the node for the given path jump
        super + {p,b,comma,period}
        	bspc node -f @{parent,brother,first,second}

        # focus the next/previous window in the current desktop
        super + {_,shift + }c
        	bspc node -f {next,prev}.local.!hidden.window

        # focus the next/previous desktop in the current monitor
        super + bracket{left,right}
        	bspc desktop -f {prev,next}.local

        # focus the last node/desktop
        super + {grave,Tab}
        	bspc {node,desktop} -f last

        # focus the older or newer node in the focus history
        super + {o,i}
        	bspc wm -h off; \
        	bspc node {older,newer} -f; \
        	bspc wm -h on

        # focus or send to the given desktop
        super + {_,shift + }{1-9,0}
        	bspc {desktop -f,node -d} '^{1-9,10}'

        #
        # preselect
        #

        # preselect the direction
        super + ctrl + {h,j,k,l}
        	bspc node -p {west,south,north,east}

        # preselect the ratio
        super + ctrl + {1-9}
        	bspc node -o 0.{1-9}

        # cancel the preselection for the focused node
        super + ctrl + space
        	bspc node -p cancel

        # cancel the preselection for the focused desktop
        super + ctrl + shift + space
        	bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel

        #
        # move/resize
        #

        # expand a window by moving one of its side outward
        super + alt + {h,j,k,l}
        	bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}

        # contract a window by moving one of its side inward
        super + alt + shift + {h,j,k,l}
        	bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}

        # move a floating window
        super + {Left,Down,Up,Right}
        	bspc node -v {-20 0,0 20,0 -20,20 0}

        XF86MonBrightnessUp
        	brightnessctl s +5%

        XF86MonBrightnessDown
        	brightnessctl s 5%-
      '';
      executable = true;
    };

    ".config/polybar/config.ini".text = ''
      [colors]
      background = #16161D
      background-alt = #1F1F28
      foreground = #DCD7BA
      primary = #7E9CD8
      secondary = #938AA9
      alert = #E82424
      disabled = #363646
      [bar/example]
      width = 100%
      height = 24pt
      radius = 0
      ; dpi = 96
      background = ''${colors.background}
      foreground = ''${colors.foreground}
      line-size = 3pt
      border-size = 0pt
      border-color = #00000000
      padding-left = 0
      padding-right = 1
      module-margin = 1
      separator = |
      separator-foreground = ''${colors.disabled}
      font-0 = monospace;2
      modules-left = xworkspaces xwindow
      modules-right = filesystem pulseaudio xkeyboard memory cpu battery date
      cursor-click = pointer
      cursor-scroll = ns-resize
      enable-ipc = true
      tray-position = right
      ; wm-restack = generic
      wm-restack = bspwm
      ; wm-restack = i3
      ; override-redirect = true
      [module/xworkspaces]
      type = internal/xworkspaces
      label-active = %name%
      label-active-background = ''${colors.background-alt}
      label-active-underline= ''${colors.primary}
      label-active-padding = 1
      label-occupied = %name%
      label-occupied-padding = 1
      label-urgent = %name%
      label-urgent-background = ''${colors.alert}
      label-urgent-padding = 1
      label-empty = %name%
      label-empty-foreground = ''${colors.disabled}
      label-empty-padding = 1
      [module/xwindow]
      type = internal/xwindow
      label = %title:0:60:...%
      [module/filesystem]
      type = internal/fs
      interval = 25
      mount-0 = /
      label-mounted = %{F#F0C674}%mountpoint%%{F-} %percentage_used%%

      label-unmounted = %mountpoint% not mounted
      label-unmounted-foreground = ''${colors.disabled}

      [module/pulseaudio]
      type = internal/pulseaudio

      format-volume-prefix = "VOL "
      format-volume-prefix-foreground = ''${colors.primary}
      format-volume = <label-volume>

      label-volume = %percentage%%

      label-muted = muted
      label-muted-foreground = ''${colors.disabled}

      [module/xkeyboard]
      type = internal/xkeyboard
      blacklist-0 = num lock

      label-layout = %layout%
      label-layout-foreground = ''${colors.primary}

      label-indicator-padding = 2
      label-indicator-margin = 1
      label-indicator-foreground = ''${colors.background}
      label-indicator-background = ''${colors.secondary}

      [module/memory]
      type = internal/memory
      interval = 2
      format-prefix = "RAM "
      format-prefix-foreground = ''${colors.primary}
      label = %percentage_used:2%%

      [module/cpu]
      type = internal/cpu
      interval = 2
      format-prefix = "CPU "
      format-prefix-foreground = ''${colors.primary}
      label = %percentage:2%%

      [network-base]
      type = internal/network
      interval = 5
      format-connected = <label-connected>
      format-disconnected = <label-disconnected>
      label-disconnected = %{F#F0C674}%ifname%%{F#707880} disconnected

      [module/wlan]
      inherit = network-base
      interface-type = wireless
      label-connected = %ifname% %essid% %local_ip%

      [module/eth]
      inherit = network-base
      interface-type = wired
      label-connected = %{F#F0C674}%ifname%%{F-} %local_ip%

      [module/date]
      type = internal/date
      interval = 1

      date = %H:%M
      date-alt = %Y-%m-%d %H:%M:%S

      label = %date%
      label-foreground = ''${colors.primary}

      [module/battery]
      type = internal/battery

      ; This is useful in case the battery never reports 100% charge
      ; Default: 100
      full-at = 99

      ; format-low once this charge percentage is reached
      ; Default: 10
      ; New in version 3.6.0
      low-at = 5

      ; Use the following command to list batteries and adapters:
      ; $ ls -1 /sys/class/power_supply/
      battery = BAT1
      adapter = ADP1

      ; If an inotify event haven't been reported in this many
      ; seconds, manually poll for new values.
      ;
      ; Needed as a fallback for systems that don't report events
      ; on sysfs/procfs.
      ;
      ; Disable polling by setting the interval to 0.
      ;
      ; Default: 5
      poll-interval = 5

      [settings]
      screenchange-reload = true
      pseudo-transparency = true

      ; vim:ft=dosini
    '';
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".config/polybar/launch.sh" = {
      text = ''
        #!/usr/bin/env bash

        # Terminate already running bar instances
        # If all your bars have ipc enabled, you can use 
        polybar-msg cmd quit
        # Otherwise you can use the nuclear option:
        # killall -q polybar

        # Launch bar1 and bar2
        echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
        polybar -r example 2>&1 | tee -a /tmp/polybar1.log & disown

        echo "Bars launched..."
      '';
      executable = true;
    };

    ".config/alacritty/alacritty.yml".text = ''
      font:
        normal:
          family: Hasklug Nerd Font Mono
          style: Regular
        size: 11.0
    '';
    ".config/helix/config.toml".text = ''
      theme="kanagawa_trans"

      [editor]
      line-number = "relative"
      mouse = false
      completion-trigger-len = 2
      shell = ["bash", "-c"]
      auto-save = true
      bufferline = "multiple"
      true-color = true

      [editor.lsp]
      display-messages = true
      display-inlay-hints = true

      [editor.cursor-shape]
      insert = "bar"
      normal = "block"
      select = "underline"

      [editor.file-picker]
      hidden = false

      [editor.statusline]
      mode.normal = "NORMAL"
      mode.insert = "INSERT"
      mode.select = "SELECT"
      left = ["mode", "separator", "file-name"]
      center = ["spinner"]
      right = ["diagnostics", "selections", "position", "file-encoding"]
      separator = "|"
    '';
    ".config/helix/runtime/themes/kanagawa_trans.toml".text = ''
      inherits = "kanagawa"
      "ui.background" = { fg = "foreground" }
    '';
    
  };
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
  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/vavakado/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    EDITOR = "hx";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
