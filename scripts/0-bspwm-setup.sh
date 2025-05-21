#!/bin/bash

# BSPWM Setup Script for Arch Linux
# This script installs and configures BSPWM window manager on a fresh Arch Linux installation

# Error handling
set -e

echo "Starting BSPWM setup for Arch Linux..."

# Update system first
echo "Updating system packages..."
sudo pacman -Syu --noconfirm

# Install necessary packages
echo "Installing BSPWM and required packages..."
sudo pacman -S --needed --noconfirm bspwm sxhkd xorg xorg-xinit alacritty picom rofi polybar feh nitrogen thunar xorg-xsetroot xorg-xbacklight pulseaudio pamixer firefox git

# Create necessary directories
echo "Creating configuration directories..."
mkdir -p ~/.config/{bspwm,sxhkd,polybar,picom}

# Create bspwmrc configuration
echo "Creating bspwmrc configuration..."
cat > ~/.config/bspwm/bspwmrc << 'EOF'
#!/bin/sh

# Start sxhkd if not already running
pgrep -x sxhkd > /dev/null || sxhkd &

# Set cursor
xsetroot -cursor_name left_ptr

# Start compositor
picom -b &

# Set wallpaper
nitrogen --restore &

# Start polybar
polybar example &

# Set workspaces/desktops
bspc monitor -d I II III IV V VI VII VIII IX X

# Border and gap settings
bspc config border_width         2
bspc config window_gap          10

bspc config split_ratio          0.52
bspc config borderless_monocle   true
bspc config gapless_monocle      true

# Window rules
bspc rule -a Gimp desktop='^8' state=floating follow=on
bspc rule -a Firefox desktop='^2'
bspc rule -a Thunar desktop='^3'
bspc rule -a Alacritty desktop='^1'
EOF

# Make bspwmrc executable
chmod +x ~/.config/bspwm/bspwmrc

# Create sxhkdrc configuration
echo "Creating sxhkdrc configuration..."
cat > ~/.config/sxhkd/sxhkdrc << 'EOF'
# Terminal
super + Return
    alacritty

# Program launcher
super + @space
    rofi -show drun

# Reload sxhkd config
super + Escape
    pkill -USR1 -x sxhkd

# Quit/restart bspwm
super + alt + {q,r}
    bspc {quit,wm -r}

# Close and kill
super + {_,shift + }w
    bspc node -{c,k}

# Alternate between the tiled and monocle layout
super + m
    bspc desktop -l next

# Set the window state
super + {t,shift + t,s,f}
    bspc node -t {tiled,pseudo_tiled,floating,fullscreen}

# Focus the node in the given direction
super + {_,shift + }{h,j,k,l}
    bspc node -{f,s} {west,south,north,east}

# Focus or send to the given desktop
super + {_,shift + }{1-9,0}
    bspc {desktop -f,node -d} '^{1-9,10}'

# Expand a window by moving one of its side outward
super + alt + {h,j,k,l}
    bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}

# Contract a window by moving one of its side inward
super + alt + shift + {h,j,k,l}
    bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}

# Audio controls
XF86AudioRaiseVolume
    pamixer -i 5

XF86AudioLowerVolume
    pamixer -d 5

XF86AudioMute
    pamixer -t
EOF

# Create a basic .xinitrc file
echo "Creating .xinitrc file..."
cat > ~/.xinitrc << 'EOF'
#!/bin/sh

# Start window manager
exec bspwm
EOF
chmod +x ~/.xinitrc

# Setup polybar config
echo "Setting up polybar..."
cat > ~/.config/polybar/config.ini << 'EOF'
[bar/example]
width = 100%
height = 24
radius = 0.0
fixed-center = true

background = #222
foreground = #dfdfdf

line-size = 2
line-color = #00f

padding-left = 0
padding-right = 2

module-margin-left = 1
module-margin-right = 1

font-0 = fixed:pixelsize=10;1
font-1 = unifont:fontformat=truetype:size=8:antialias=false;0

modules-left = bspwm
modules-center = xwindow
modules-right = date

[module/xwindow]
type = internal/xwindow
label = %title:0:30:...%

[module/bspwm]
type = internal/bspwm

label-focused = %index%
label-focused-background = #3f3f3f
label-focused-underline= #fba922
label-focused-padding = 2

label-occupied = %index%
label-occupied-padding = 2

label-urgent = %index%!
label-urgent-background = #bd2c40
label-urgent-padding = 2

label-empty = %index%
label-empty-foreground = #55
label-empty-padding = 2

[module/date]
type = internal/date
interval = 5

date =
date-alt = " %Y-%m-%d"

time = %H:%M
time-alt = %H:%M:%S

format-prefix-foreground = #0a6cf5
format-underline = #0a6cf5

label = %date% %time%
EOF

# Create directories for wallpapers
mkdir -p ~/Pictures/Wallpapers

echo "BSPWM setup completed!"
echo "You can now start BSPWM with 'startx'"
echo "Press Super + Return to open a terminal"
echo "Press Super + Space to open the application menu"