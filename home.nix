{ config, pkgs, ... }:

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
    ".config/bspwm/bspwmrc".text = ''
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
 
    ".config/sxhkd/sxhkdrc".text = ''
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
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  
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
