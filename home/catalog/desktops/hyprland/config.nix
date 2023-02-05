''
    # Monitorsss
    monitor=DP-3,preferred,1505x0,1.2
    monitor=DP-2,preferred,0x890,1.2
    monitor=DP-2,addreserved,0,0,700,700

    # Autostart programs
    # exec-once = xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2
    exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec-once = /home/gogsaan/.config/vpn/addConnection.sh
    exec-once = waybar
    exec-once = swaybg --mode fill --image /home/gogsaan/Pictures/wallpapers/nixos/cat_leaves.png
    exec-once = obsidian
    exec-once = 1password
    exec-once = swayidle -w
    exec-once = hyprlandWorkspaceMonitorFix
    exec-once = htop


    # Inputs
    input {
      kb_layout = us,se
      kb_variant =
      kb_model =
      kb_options = grp:rwin_toggle
      kb_rules =
      follow_mouse = 1
      # touchpad {
      #     disable_while_typing = true
      #     natural_scroll = true
      #     tap-to-click = true
      # }
      sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
    }


    # General
    binds {
      allow_workspace_cycles = false
    }

    # General
    general {
      gaps_in = 6
      gaps_out = 12
      border_size = 2
      col.active_border= 0xffcba6f7 0xfff38ba8 45deg
      no_border_on_floating = false
      layout = dwindle
      # main_mod = SUPER
    }
    # Misc
    misc {
      disable_hyprland_logo = true
      disable_splash_rendering = true
      mouse_move_enables_dpms = true
      no_vfr = true
      enable_swallow = true
      swallow_regex = ^(kitty)$
    }

    # Decorations
    decoration {
      # Rounded corners
      rounding = 6
      multisample_edges = true

      # Opacity
      active_opacity = 1.0
      inactive_opacity = 1.0

      # Blur
      blur = true
      blur_size = 10
      blur_passes = 4
      blur_new_optimizations = true

      # Shadow
      drop_shadow = true
      shadow_ignore_window = true
      shadow_offset = 2 2
      shadow_range = 4
      shadow_render_power = 2
      col.shadow = 0x66000000
      dim_special = 0
      dim_inactive = false
      dim_strength = 0.6
    }

    # Blurring layerSurfaces
    blurls = gtk-layer-shell
    blurls = waybar
    blurls = lockscreen

    # Animations
    animations {
      enabled = true
      # bezier curve
      bezier = linear, 0, 0, 1, 1
      bezier = overshot, 0.05, 0.9, 0.1, 1.05
      # bezier = overshot, 0.13, 0.99, 0.29, 1.1
      bezier = smoothOut, 0.36, 0, 0.66, -0.56
      bezier = smoothIn, 0.25, 1, 0.5, 1
      # animation list
      animation = windows, 1, 3, overshot, slide
      animation = windowsOut, 1, 10, smoothOut, slide
      animation = windowsMove, 1, 3, default

      animation = fade, 1, 7, smoothIn
      animation = fadeDim, 1, 7, smoothIn
      animation = workspaces, 1, 4, overshot, slidevert
      #animation = border, 1, 5, default
      #animation=workspaces,1,1,default,fade
      #animation = border,1,2,linear
      animation = borderangle, 1, 15, linear, loop
    }

    # Gestures
    # gestures {
    #   workspace_swipe = true
    #   workspace_swipe_fingers = 3
    # }

    # Layouts
    dwindle {
      col.group_border=0xff313244
      col.group_border_active	=0xffcba6f7 0xfff38ba8 45deg
      no_gaps_when_only = false
      pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
      preserve_split = true # you probably want this
    }

    # Window rules
    windowrule = float, file_progress
    windowrule = float, confirm
    windowrule = float, dialog
    windowrule = float, download
    windowrule = float, notification
    windowrule = float, error
    windowrule = float, splash
    windowrule = float, confirmreset
    windowrule = float, title:Open File
    windowrule = float, title:branchdialog
    windowrule = float, zoom
    windowrule = float, vlc
    windowrule = float, Lxappearance
    windowrule = float, ncmpcpp
    windowrule = float, Rofi
    windowrule = animation none, Rofi
    windowrule = float, viewnior
    windowrule = float, pavucontrol-qt
    windowrule = float, gucharmap
    windowrule = float, gnome-font
    windowrule = float, org.gnome.Settings
    windowrule = float, file-roller
    # windowrule = float, nautilus
    # windowrule = float, nemo
    windowrule = float, thunar
    windowrule = float, Pcmanfm
    windowrule = float, obs
    windowrule = float, wdisplays
    windowrule = float, zathura
    # windowrule = float, *.exe
    windowrule = fullscreen, wlogout
    windowrule = float, title:wlogout
    windowrule = fullscreen, title:wlogout
    windowrule = float, pavucontrol-qt
    windowrule = float, keepassxc
    windowrule = idleinhibit focus, mpv
    windowrule = idleinhibit fullscreen, firefox
    windowrule = float, title:^(Media viewer)$
    # windowrule = float, title:^(Mount and Blade II Bannerlord)$
    windowrule = float, title:^(Transmission)$
    windowrule = float, title:^(Volume Control)$
    windowrule = float, title:^(Picture-in-Picture)$
    windowrule = float, title:^(Firefox — Sharing Indicator)$
    windowrule = move 0 0, title:^(Firefox — Sharing Indicator)$
    windowrule = size 800 600, title:^(Volume Control)$
    windowrule = move 75 44%, title:^(Volume Control)$

    windowrule = float, title:^(swappy)$
    windowrule = move 35% 10%, title:^(swappy)$

    windowrule = workspace special:music, title:^(YouTube Music)$
    windowrule = workspace special:obsidian, title:^.*private - Obsidian.*$
    windowrule = workspace 10, title:^.*WebCord.*$
    windowrule = workspace 10, title:^.*Skype.*$
    windowrule = workspace 10, title:^.*Signal.*$
    windowrule = workspace 3, title:^(htop)$
    windowrule = float, title:^(htop)$

    # Navicat Premium
    windowrule = float, title:^.*New Connection.*$
    windowrule = move 0 0, title:^.*New Connection.*$
    windowrule = float, title:^.*Edit Connection.*$
    windowrule = move 0 0, title:^.*Edit Connection.*$

  # Variables
  $term = kitty
  $browser = firefox
  $editor = code
  $files = nemo
  $launcher = killall rofi || rofi -no-lazy-grab -show drun -theme index  -sort
  # $launcher = killall wofi || wofi -S drun
  $emoji = killall rofi || rofi -show emoji -emoji-format "{emoji}" -modi emoji -theme emoji


  # See https://wiki.hyprland.org/Configuring/Keywords/ for more
  $mainMod = SUPER

  # VPN
  bind=SUPER,n, exec, nmcli connection up ikea passwd-file ~/.config/vpn/passwd
  bind=SUPERSHIFT,n, exec, nmcli connection down ikea

  # Reset workspaces
  bind=SUPER,G,exec, hyprctl dispatch moveworkspacetomonitor 1 DP-2 && hyprctl dispatch moveworkspacetomonitor 2 DP-2 && hyprctl dispatch moveworkspacetomonitor 3 DP-2 && hyprctl dispatch moveworkspacetomonitor 4 DP-2 && hyprctl dispatch moveworkspacetomonitor 5 DP-2 && hyprctl dispatch moveworkspacetomonitor 6 DP-2 && hyprctl dispatch moveworkspacetomonitor 7 DP-3 && hyprctl dispatch moveworkspacetomonitor 8 DP-3 && hyprctl dispatch moveworkspacetomonitor 9 DP-3 && hyprctl dispatch moveworkspacetomonitor 10 DP-2
  bind=SUPER,G,exec, hyprctl dispatch workspace 1 && hyprctl dispatch workspace 2 && hyprctl dispatch workspace 3 && hyprctl dispatch workspace 4 && hyprctl dispatch workspace 5 && hyprctl dispatch workspace 6 && hyprctl dispatch workspace 7 && hyprctl dispatch workspace 8 && hyprctl dispatch workspace 9 && hyprctl dispatch workspace 10 && hyprctl dispatch workspace 6 && hyprctl dispatch workspace 1 && $statusbar

  # DDC control
  bind=$mainMod,A,exec, ddcutil --bus=7 setvcp 10 0 & ddcutil --bus=8 setvcp 10 0
  bind=$mainModSHIFT,A,exec, ddcutil --bus=7 setvcp 10 100 & ddcutil --bus=8 setvcp 10 100

  #bind=$mainMod,F12,swapactiveworkspaces,DP-2 DP-3

  bind=$mainMod,B,exec,swaync-client -t -sw
  bind=$mainMod,V,exec,swaync-client -C -sw && swaync-client -cp -sw

  bind=$mainModSHIFT,Return,exec,$browser
  bind=$mainModCTRL,Return,exec,google-chrome-beta

  bind=$mainMod,A,exec, ~/.config/dots/scripts/dcc dark
  bind=$mainModSHIFT,A,exec, ~/.config/dots/scripts/dcc light

  bind=$mainMod,Return,exec,$term
  # bind=CTRL,RETURN,exec,$term
  bind=$mainMod,Q,killactive,

  # bindr=SUPER, SUPER_L, exec, pkill $launcher || $launcher

  bind=$mainMod, D, exec, $launcher
  bind=$mainMod,F,fullscreen
  bind=$mainModSHIFT,backslash, exec, pkill waybar || waybar

    # DP-2,2560x1080@120,850x900,1
    # DP-2,addreserved,0,0,0,0
    # DP-2,highrr,0x890,1.2
    # DP-2,addreserved,0,0,700,700

  # Screen resolution
  bind=$mainMod, slash, exec, hyprctl keyword monitor "DP-2,highrr,0x890,1.2"
  bind=$mainMod, slash, exec, hyprctl keyword monitor "DP-2,addreserved,0,0,700,700"
  bind=$mainModSHIFT, slash, exec, hyprctl keyword monitor "DP-2,2560x1080@120,850x900,1"
  bind=$mainModSHIFT, slash, exec, hyprctl keyword monitor "DP-2,addreserved,0,0,0,0"

  # Special worspace
  bind=SUPERCTRL,7,movetoworkspace,special:music
  bind=SUPERCTRL,8,movetoworkspace,special:obsidian
  bind=SUPERCTRL,9,movetoworkspace,special:chatgpt
  bind=SUPERCTRL,0,movetoworkspace,special:pomo

  bind=SUPER,Tab,togglespecialworkspace,music
  bind=$mainModALT,F12,togglespecialworkspace,obsidian
  bind=$mainMod_SHIFT,Tab,togglespecialworkspace,pomo
  bind=$mainMod_ALT_SHIFT,F12,togglespecialworkspace,chatgpt


  # FLY IS KITTY
  windowrule=move center,title:^(fly_is_kitty)$
  windowrule=size 800 500,title:^(fly_is_kitty)$
  windowrule=float,title:^(fly_is_kitty)$

  # Groups
  bind=$mainMod,W,togglegroup,
  bind=ALT,Left,changegroupactive, b
  bind=ALT,Right,changegroupactive, f

  # Ser resolution


  # Padding
  # bind=SUPER,E,exec, hyprctl keyword monitor DP-2,addreserved,0,0,1200,1200
  bind=SUPER,E,exec, hyprctl keyword monitor DP-2,addreserved,0,0,700,700
  bind=SUPER,R,exec, hyprctl keyword monitor DP-2,addreserved,0,0,500,500
  bind=SUPER,T,exec, hyprctl keyword monitor DP-2,addreserved,0,0,0,0

  # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
  bind = $mainMod, C, killactive,
  bind = $mainMod, M, exit,
  bind = ALT, F, togglefloating,
  bind = $mainMod, P, pseudo, # dwindle
  bind = $mainMod, J, togglesplit, # dwindle

  # Move focus with mainMod + arrow keys
  bind = $mainMod, left, movefocus, l
  bind = $mainMod, right, movefocus, r
  bind = $mainMod, up, movefocus, u
  bind = $mainMod, down, movefocus, d


  # Function keys
  # bind = ,XF86MonBrightnessUp, exec, brightness set +5%
  # bind = ,XF86MonBrightnessDown, exec, brightness set 5%-
  # bind = ,XF86AudioMute, exec, volume -t
  # bind = ,XF86AudioMicMute, exec, microphone -t

  bind=,XF86AudioNext,exec,playerctl next
  bind=,XF86AudioPrev,exec,playerctl previous
  bind=,XF86AudioPlay,exec,playerctl play-pause
  bind=,XF86AudioStop,exec,playerctl stop
  bind = ,XF86AudioRaiseVolume, exec, volume -i 5
  bind = ,XF86AudioLowerVolume, exec, volume -d 5


  # Screenshots
  $screenshotarea = hyprctl keyword animation "fadeOut,0,0,5"; grimblast --cursor save area - | swappy -f - ; hyprctl keyword animation "fadeOut,1,4,5"
  $screensscreen = hyprctl keyword animation "fadeOut,0,0,5"; grimblast --cursor save active - | swappy -f - ; hyprctl keyword animation "fadeOut,1,4,5"

  bind = SUPER_SHIFT, t, exec, $screenshotarea
  bind = SUPER_CTRL, t, exec, $screensscreen
  bind = CTRL, Print, exec, grimblast --notify --cursor copysave output
  bind = SUPER SHIFT CTRL, R, exec, grimblast --notify --cursor copysave output
  bind = ALT, Print, exec, grimblast --notify --cursor copysave screen
  bind = SUPER SHIFT ALT, R, exec, grimblast --notify --cursor copysave screen


  # Move
  bind=SUPERSHIFT,left,movewindow,l
  bind=SUPERSHIFT,right,movewindow,r
  bind=SUPERSHIFT,up,movewindow,u
  bind=SUPERSHIFT,down,movewindow,d

  # Resize
  binde=SUPERCTRL,left,resizeactive,-80 0
  binde=SUPERCTRL,right,resizeactive,80 0
  binde=SUPERCTRL,up,resizeactive,0 -80
  binde=SUPERCTRL,down,resizeactive,0 80

  # Switch workspaces with mainMod + [0-9]
  bind = $mainMod, 1, workspace, 1
  bind = $mainMod, 2, workspace, 2
  bind = $mainMod, 3, workspace, 3
  bind = $mainMod, 4, workspace, 4
  bind = $mainMod, 5, workspace, 5
  bind = $mainMod, 6, workspace, 6
  bind = $mainMod, 7, workspace, 7
  bind = $mainMod, 8, workspace, 8
  bind = $mainMod, 9, workspace, 9
  bind = $mainMod, 0, workspace, 10
  bind = $mainMod, ESCAPE, workspace, 10

  # Workspaces --------------------------------------------------
  workspace=DP-2,1
  workspace=DP-3,7

  wsbind=1,DP-2
  wsbind=2,DP-2
  wsbind=3,DP-2
  wsbind=4,DP-2
  wsbind=5,DP-2
  wsbind=6,DP-2
  wsbind=7,DP-3
  wsbind=8,DP-3
  wsbind=9,DP-3
  wsbind=0,DP-2

  # Move active window to a workspace with mainMod + SHIFT + [0-9]
  bind = $mainMod SHIFT, 1, movetoworkspace, 1
  bind = $mainMod SHIFT, 2, movetoworkspace, 2
  bind = $mainMod SHIFT, 3, movetoworkspace, 3
  bind = $mainMod SHIFT, 4, movetoworkspace, 4
  bind = $mainMod SHIFT, 5, movetoworkspace, 5
  bind = $mainMod SHIFT, 6, movetoworkspace, 6
  bind = $mainMod SHIFT, 7, movetoworkspace, 7
  bind = $mainMod SHIFT, 8, movetoworkspace, 8
  bind = $mainMod SHIFT, 9, movetoworkspace, 9
  bind = $mainMod SHIFT, 0, movetoworkspace, 10
  bind = $mainMod SHIFT, ESCAPE, movetoworkspace, 10

  # Scroll through existing workspaces with mainMod + scroll
  # bind = $mainMod, mouse_down, workspace, previous
  # bind = $mainMod, mouse_up, workspace, previous

  bind = ALT, F12, workspace, previous

  # Move/resize windows with mainMod + LMB/RMB and dragging
  bindm = $mainMod, mouse:272, movewindow
  bindm = $mainMod, mouse:273, resizewindow


  # Mouse bindings
  bindm = SUPER, mouse:272, movewindow
  bindm = SUPER, mouse:273, resizewindow
''
