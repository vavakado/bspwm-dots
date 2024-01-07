{ ... }:
{
  home.file = {
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
  };
}
