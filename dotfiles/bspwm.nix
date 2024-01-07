{ ... }: 
{
  
    home.file = {
      ".config/bspwm/bspwmrc" = { 
        text = ''
          #! /bin/sh
          pgrep -x sxhkd > /dev/null || sxhkd &
          #feh --bg-scale /home/vavakado/wall.jpg
          feh --bg-scale /home/vavakado/Downloads/wallhaven-q2vzd7_1920x1080.png
          pipewire &
          picom --config ~/.config/picom/picom.sample.conf &
          ~/.config/polybar/launch.sh &
          setxkbmap -layout "us,ru" -option 'grp:win_space_toggle'

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
    };
}
